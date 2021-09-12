Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F82407C40
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 09:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhILHtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 03:49:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233071AbhILHtR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 03:49:17 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18C3E0rA013969;
        Sun, 12 Sep 2021 03:46:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AbgEci5Ku0ckeMfcoizBo7q6044PcSVA9J4TV9p8xVE=;
 b=XWvNXO2BH4qDekOrwAPp8NPBt8WAQQasMLGtv2Uqw3IcuTWnJKUDoJ1kDUwkKgAwTdKx
 jOIM1xWQgoGzXD7kFKIyBG5ch1OYlBud64Q4oiCRmUO/pbEjYGS76NUXnSna6VtSQPm6
 AOMDMO7vJSCPxiLbNIuQ9YKAeWdSQY+ioeZgzehAvvnqEml7KW+oCLKJMlzafeloJUW+
 /qGGNq3Cy4RavKgeObK0JNWawChBKbvkHxEKG0yAy72My8YelNqwrihtkH/kGjkIfq7z
 uT1g8St1eGcpRI91pbQg2Opc5Y/pH0ZfX58/LgHfpY4bTHACglW+A5Iht2K6Z31xrVAx rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b19fcjncj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Sep 2021 03:46:59 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18C7kwRw023730;
        Sun, 12 Sep 2021 03:46:58 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b19fcjnc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Sep 2021 03:46:58 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18C7kk7k019694;
        Sun, 12 Sep 2021 07:46:57 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 3b0m390pb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Sep 2021 07:46:57 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18C7ktIq30212554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 12 Sep 2021 07:46:55 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7316E13605D;
        Sun, 12 Sep 2021 07:46:55 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29538136055;
        Sun, 12 Sep 2021 07:46:48 +0000 (GMT)
Received: from [9.65.84.185] (unknown [9.65.84.185])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 12 Sep 2021 07:46:47 +0000 (GMT)
Subject: Re: [PATCH Part2 v5 18/45] crypto: ccp: Provide APIs to query
 extended attestation report
To:     Marc Orr <marcorr@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-19-brijesh.singh@amd.com>
 <CAA03e5FMCp7cZLXKPZ53SOUK-cOF+WmGRj256K9=+wivHvTA0Q@mail.gmail.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <d6fd2456-999b-37eb-64c2-04d33f7a8ffd@linux.ibm.com>
Date:   Sun, 12 Sep 2021 10:46:46 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAA03e5FMCp7cZLXKPZ53SOUK-cOF+WmGRj256K9=+wivHvTA0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _GvBj-xBa9VfD13iv1w1scnHmIZR6Rlk
X-Proofpoint-GUID: BWjJ6Y36gh4JVUx2Zc6w3fByrpOooEfk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 bulkscore=0 phishscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109120023
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/09/2021 6:30, Marc Orr wrote:
> On Fri, Aug 20, 2021 at 9:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>>
>> Version 2 of the GHCB specification defines VMGEXIT that is used to get
>> the extended attestation report. The extended attestation report includes
>> the certificate blobs provided through the SNP_SET_EXT_CONFIG.
>>
>> The snp_guest_ext_guest_request() will be used by the hypervisor to get
>> the extended attestation report. See the GHCB specification for more
>> details.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 43 ++++++++++++++++++++++++++++++++++++
>>  include/linux/psp-sev.h      | 24 ++++++++++++++++++++
>>  2 files changed, 67 insertions(+)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 9ba194acbe85..e2650c3d0d0a 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -22,6 +22,7 @@
>>  #include <linux/firmware.h>
>>  #include <linux/gfp.h>
>>  #include <linux/cpufeature.h>
>> +#include <linux/sev-guest.h>
>>
>>  #include <asm/smp.h>
>>
>> @@ -1677,6 +1678,48 @@ int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
>>  }
>>  EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt);
>>
>> +int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
>> +                               unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
>> +{
>> +       unsigned long expected_npages;
>> +       struct sev_device *sev;
>> +       int rc;
>> +
>> +       if (!psp_master || !psp_master->sev_data)
>> +               return -ENODEV;
>> +
>> +       sev = psp_master->sev_data;
>> +
>> +       if (!sev->snp_inited)
>> +               return -EINVAL;
>> +
>> +       /*
>> +        * Check if there is enough space to copy the certificate chain. Otherwise
>> +        * return ERROR code defined in the GHCB specification.
>> +        */
>> +       expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
> 
> Is this calculation for `expected_npages` correct? Assume that
> `sev->snp_certs_len` is less than a page (e.g., 2000). Then, this
> calculation will return `0` for `expected_npages`, rather than round
> up to 1.
> 

In patch 17 in sev_ioctl_snp_set_config there's a check that certs_len
is aligned to PAGE_SIZE (and this value is later in that function assigned
to sev->snp_certs_len):

+	/* Copy the certs from userspace */
+	if (input.certs_address) {
+		if (!input.certs_len || !IS_ALIGNED(input.certs_len, PAGE_SIZE))
+			return -EINVAL;

but I agree that rounding up (DIV_ROUND_UP) or asserting that
sev->snp_certs_len is aligned to PAGE_SIZE (and non-zero) makes
sense here.


-Dov


>> +       if (*npages < expected_npages) {
>> +               *npages = expected_npages;
>> +               *fw_err = SNP_GUEST_REQ_INVALID_LEN;
>> +               return -EINVAL;
>> +       }
>> +
>> +       rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)&fw_err);
>> +       if (rc)
>> +               return rc;
>> +
>> +       /* Copy the certificate blob */
>> +       if (sev->snp_certs_data) {
>> +               *npages = expected_npages;
>> +               memcpy((void *)vaddr, sev->snp_certs_data, *npages << PAGE_SHIFT);
>> +       } else {
>> +               *npages = 0;
>> +       }
>> +
>> +       return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(snp_guest_ext_guest_request);
>> +
>>  static void sev_exit(struct kref *ref)
>>  {
>>         misc_deregister(&misc_dev->misc);
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 00bd684dc094..ea94ce4d834a 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -924,6 +924,23 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
>>  void *snp_alloc_firmware_page(gfp_t mask);
>>  void snp_free_firmware_page(void *addr);
>>
>> +/**
>> + * snp_guest_ext_guest_request - perform the SNP extended guest request command
>> + *  defined in the GHCB specification.
>> + *
>> + * @data: the input guest request structure
>> + * @vaddr: address where the certificate blob need to be copied.
>> + * @npages: number of pages for the certificate blob.
>> + *    If the specified page count is less than the certificate blob size, then the
>> + *    required page count is returned with error code defined in the GHCB spec.
>> + *    If the specified page count is more than the certificate blob size, then
>> + *    page count is updated to reflect the amount of valid data copied in the
>> + *    vaddr.
>> + */
>> +int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
>> +                               unsigned long vaddr, unsigned long *npages,
>> +                               unsigned long *error);
>> +
>>  #else  /* !CONFIG_CRYPTO_DEV_SP_PSP */
>>
>>  static inline int
>> @@ -971,6 +988,13 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
>>
>>  static inline void snp_free_firmware_page(void *addr) { }
>>
>> +static inline int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
>> +                                             unsigned long vaddr, unsigned long *n,
>> +                                             unsigned long *error)
>> +{
>> +       return -ENODEV;
>> +}
>> +
>>  #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>>
>>  #endif /* __PSP_SEV_H__ */
>> --
>> 2.17.1
>>
