Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED846A7B25
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 07:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjCBGBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 01:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBGBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 01:01:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09684D613;
        Wed,  1 Mar 2023 22:01:10 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32252Z1k027917;
        Thu, 2 Mar 2023 05:59:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wUdfnguh4H8PLzbalZbcZFqO3C4N0DClhybUCKsJD00=;
 b=QgRVPGU6Mys64aRBI4Eo5frRm7YMTrCIYglVT5ffGukrjzdlrux9wTDTVvO+qn2MYuRc
 4NRc0mD5AR3mzJB+mtm0cxGo+q6z5/uohubiiVZHmC6x0sGx/yE4llG9rVcSqAy5wDhp
 50FyLMeg90yso9RxcV2voTU7SfpyKUxq+ESRscWeXowvQeQLO1DXGa25iIJBSNr2PyF6
 sLlR0G1fH/ISx5eiqsDx5ORXL7ujtsIVaOeAxxLWiVgWqqwbThnfIaAwrtldhKael82e
 GKG/2dsJ1My2WI1enj/S+74Bx5FtIwiHvb6BmIHQIuPlwqZBJtIl8cvRV1zY/vuUx5+Q cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p2naah3ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Mar 2023 05:59:40 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3225uW8K004481;
        Thu, 2 Mar 2023 05:59:39 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p2naah3bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Mar 2023 05:59:39 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3224D9b2016017;
        Thu, 2 Mar 2023 05:59:38 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3nybdm1vwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Mar 2023 05:59:38 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3225xaEd53936468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Mar 2023 05:59:36 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F5225805D;
        Thu,  2 Mar 2023 05:59:36 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9538B5805C;
        Thu,  2 Mar 2023 05:59:26 +0000 (GMT)
Received: from [9.65.199.252] (unknown [9.65.199.252])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  2 Mar 2023 05:59:26 +0000 (GMT)
Message-ID: <e63ba525-644d-1a8c-afe7-2ced4a8fbb93@linux.ibm.com>
Date:   Thu, 2 Mar 2023 07:59:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v8 52/56] ccp: Add support to decrypt the page
To:     Zhi Wang <zhi.wang.linux@gmail.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-53-michael.roth@amd.com>
 <20230301232045.0000502e@intel.com>
Content-Language: en-US
From:   Dov Murik <dovmurik@linux.ibm.com>
In-Reply-To: <20230301232045.0000502e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3cOt12L_luCZfkyo3GAAwwOwY32Q2VvV
X-Proofpoint-ORIG-GUID: HE5DsgxGDI6IFPFb0VeD3SZ_AWQzgOpk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-02_02,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 spamscore=0 clxscore=1011 impostorscore=0 mlxlogscore=999 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020045
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mike, Zhi,

On 01/03/2023 23:20, Zhi Wang wrote:
> On Mon, 20 Feb 2023 12:38:43 -0600
> Michael Roth <michael.roth@amd.com> wrote:
> 
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> Add support to decrypt guest encrypted memory. These API interfaces can
>> be used for example to dump VMCBs on SNP guest exit.
>>
> 
> What kinds of check will be applied from firmware when VMM decrypts this
> page? I suppose there has to be kinda mechanism to prevent VMM to decrypt
> any page in the guest. It would be nice to have some introduction about
> it in the comments.
> 

The SNP ABI spec says (section 8.27.2 SNP_DBG_DECRYPT):

  The firmware checks that the guest's policy allows debugging. If not,
  the firmware returns POLICY_FAILURE.

and in the Guest Policy (section 4.3):

  Bit 19 - DEBUG
  0: Debugging is disallowed.
  1: Debugging is allowed.

In the kernel, that firmware error code is defined as
SEV_RET_POLICY_FAILURE.


>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> [mdr: minor commit fixups]
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 32 ++++++++++++++++++++++++++++++++
>>  include/linux/psp-sev.h      | 22 ++++++++++++++++++++--
>>  2 files changed, 52 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index e65563bc8298..bf5167b2acfc 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -2017,6 +2017,38 @@ int sev_guest_df_flush(int *error)
>>  }
>>  EXPORT_SYMBOL_GPL(sev_guest_df_flush);
>>  
>> +int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
>> +{
>> +	struct sev_data_snp_dbg data = {0};
>> +	struct sev_device *sev;
>> +	int ret;
>> +
>> +	if (!psp_master || !psp_master->sev_data)
>> +		return -ENODEV;
>> +
>> +	sev = psp_master->sev_data;
>> +
>> +	if (!sev->snp_initialized)
>> +		return -EINVAL;
>> +
>> +	data.gctx_paddr = sme_me_mask | (gctx_pfn << PAGE_SHIFT);
>> +	data.src_addr = sme_me_mask | (src_pfn << PAGE_SHIFT);
>> +	data.dst_addr = sme_me_mask | (dst_pfn << PAGE_SHIFT);

I guess this works, but I wonder why we need to turn on sme_me_mask on
teh dst_addr.  I thought that the firmware decrypts the guest page
(src_addr) to a plaintext page.  Couldn't find this requirement in the
SNP spec.


>> +
>> +	/* The destination page must be in the firmware state. */
>> +	if (rmp_mark_pages_firmware(data.dst_addr, 1, false))
>> +		return -EIO;
>> +
>> +	ret = sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, &data, error);
>> +
>> +	/* Restore the page state */
>> +	if (snp_reclaim_pages(data.dst_addr, 1, false))
>> +		ret = -EIO;
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt_page);
>> +
>>  int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
>>  				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
>>  {
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 81bafc049eca..92116e2b74fd 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -710,7 +710,6 @@ struct sev_data_snp_dbg {
>>  	u64 gctx_paddr;				/* In */
>>  	u64 src_addr;				/* In */
>>  	u64 dst_addr;				/* In */
>> -	u32 len;				/* In */
>>  } __packed;

The comment above this ^^^ struct still lists the 'len' field, and also
calls the first field 'handle' instead of 'gctx_paddr'.

Also - why is this change happening in this patch? Why was the incorrect
'len' field added in the first place in "[PATCH RFC v8 20/56]
crypto:ccp: Define the SEV-SNP commands" ? (the comment fixes should
probably go there too).



>>  
>>  /**
>> @@ -913,13 +912,27 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>>   * @error: SEV command return code
>>   *
>>   * Returns:
>> + * 0 if the sev successfully processed the command
>> + * -%ENODEV    if the sev device is not available
>> + * -%ENOTSUPP  if the sev does not support SEV
>> + * -%ETIMEDOUT if the sev command timed out
>> + * -%EIO       if the sev returned a non-zero return code
>> + */

I think that if the word 'sev' would be 'SEV' in this comment, the diff
will be a bit less misleading (basically this patch should not introduce
changes to sev_do_cmd).

-Dov

>> +int sev_do_cmd(int cmd, void *data, int *psp_ret);
>> +
>> +/**
>> + * snp_guest_dbg_decrypt_page - perform SEV SNP_DBG_DECRYPT command
>> + *
>> + * @sev_ret: sev command return code
>> + *
>> + * Returns:
>>   * 0 if the SEV successfully processed the command
>>   * -%ENODEV    if the SEV device is not available
>>   * -%ENOTSUPP  if the SEV does not support SEV
>>   * -%ETIMEDOUT if the SEV command timed out
>>   * -%EIO       if the SEV returned a non-zero return code
>>   */
>> -int sev_do_cmd(int cmd, void *data, int *psp_ret);
>> +int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error);
>>  
>>  void *psp_copy_user_blob(u64 uaddr, u32 len);
>>  void *snp_alloc_firmware_page(gfp_t mask);
>> @@ -987,6 +1000,11 @@ static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_P
>>  
>>  void snp_mark_pages_offline(unsigned long pfn, unsigned int npages) {}
>>  
>> +static inline int snp_guest_dbg_decrypt_page(u64 gctx_pfn, u64 src_pfn, u64 dst_pfn, int *error)
>> +{
>> +	return -ENODEV;
>> +}
>> +
>>  static inline void *snp_alloc_firmware_page(gfp_t mask)
>>  {
>>  	return NULL;
> 
