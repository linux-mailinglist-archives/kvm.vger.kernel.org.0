Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD77B673269
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 08:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjASHZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 02:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjASHZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 02:25:21 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DF266FBD;
        Wed, 18 Jan 2023 23:24:53 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30J67eJR030173;
        Thu, 19 Jan 2023 07:23:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FaOVjx07ztTIdT60txx0s0b5gk5cg+3GhJNm7FRrqxA=;
 b=gGqM15HYRcnG3WHsQqKbdungpZdZvmGzS2AtsdqaSW/xfjHO3tqDkZ25Hz8DIWEm2B7I
 CZIrfeE1k3waUKwBNVVhBd+wbT/dshUzvjnPyhnHQ0PNJuTxFOPsnO/p0R/Zs86BeGLW
 TNW/jXn2lZeMZOoJbFtLvH735N0X2+RIqgUB05N2MU4eDKCi2j7IxHPoFCaEA5Cs13gZ
 2xvzCM1CDorHq0AVtMhIKRmiXHPq7hUFGf5MIxbu1sEP92FQgZkgLLUbJOMldpnILphX
 rc8jaP48Bu/BMhY4srYRuy7xajXYE1Lq4CXc2BrzuC5rah5fVX+eCre0o1NfExG5wx+Q QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6h5f6mkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 07:23:41 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30J7DI0V030240;
        Thu, 19 Jan 2023 07:23:40 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6h5f6mk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 07:23:40 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30J73lel009766;
        Thu, 19 Jan 2023 07:23:39 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([9.208.130.97])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3n3m1837vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 07:23:39 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30J7NbQw42271318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 07:23:37 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 868EA58059;
        Thu, 19 Jan 2023 07:23:37 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FFC358043;
        Thu, 19 Jan 2023 07:23:28 +0000 (GMT)
Received: from [9.160.127.29] (unknown [9.160.127.29])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 07:23:28 +0000 (GMT)
Message-ID: <f41e2872-a648-9c5d-88a3-23ad099dffa2@linux.ibm.com>
Date:   Thu, 19 Jan 2023 09:23:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH RFC v7 31/64] crypto: ccp: Add the
 SNP_{SET,GET}_EXT_CONFIG command
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com, Brijesh Singh <brijesh.singh@amd.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-32-michael.roth@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
In-Reply-To: <20221214194056.161492-32-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FI5em3frKKibChidKNc0sr30HSyxeZBK
X-Proofpoint-ORIG-GUID: w6COoNNAPvn6WeEFWdLfRUXz5bx9bRjg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 spamscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301190056
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mike,

On 14/12/2022 21:40, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The SEV-SNP firmware provides the SNP_CONFIG command used to set the
> system-wide configuration value for SNP guests. The information includes
> the TCB version string to be reported in guest attestation reports.
> 
> Version 2 of the GHCB specification adds an NAE (SNP extended guest
> request) that a guest can use to query the reports that include additional
> certificates.
> 
> In both cases, userspace provided additional data is included in the
> attestation reports. The userspace will use the SNP_SET_EXT_CONFIG
> command to give the certificate blob and the reported TCB version string
> at once. Note that the specification defines certificate blob with a
> specific GUID format; the userspace is responsible for building the
> proper certificate blob. The ioctl treats it an opaque blob.
> 
> While it is not defined in the spec, but let's add SNP_GET_EXT_CONFIG
> command that can be used to obtain the data programmed through the
> SNP_SET_EXT_CONFIG.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  Documentation/virt/coco/sev-guest.rst |  27 ++++++
>  drivers/crypto/ccp/sev-dev.c          | 123 ++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h          |   4 +
>  include/uapi/linux/psp-sev.h          |  17 ++++
>  4 files changed, 171 insertions(+)
> 
> diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
> index 11ea67c944df..fad1e5639dac 100644
> --- a/Documentation/virt/coco/sev-guest.rst
> +++ b/Documentation/virt/coco/sev-guest.rst
> @@ -145,6 +145,33 @@ The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
>  status includes API major, minor version and more. See the SEV-SNP
>  specification for further details.
>  
> +2.5 SNP_SET_EXT_CONFIG
> +----------------------
> +:Technology: sev-snp
> +:Type: hypervisor ioctl cmd
> +:Parameters (in): struct sev_data_snp_ext_config
> +:Returns (out): 0 on success, -negative on error
> +
> +The SNP_SET_EXT_CONFIG is used to set the system-wide configuration such as
> +reported TCB version in the attestation report. The command is similar to
> +SNP_CONFIG command defined in the SEV-SNP spec. The main difference is the
> +command also accepts an additional certificate blob defined in the GHCB
> +specification.
> +
> +If the certs_address is zero, then the previous certificate blob will deleted.
> +For more information on the certificate blob layout, see the GHCB spec
> +(extended guest request message).
> +
> +2.6 SNP_GET_EXT_CONFIG
> +----------------------
> +:Technology: sev-snp
> +:Type: hypervisor ioctl cmd
> +:Parameters (in): struct sev_data_snp_ext_config
> +:Returns (out): 0 on success, -negative on error
> +
> +The SNP_SET_EXT_CONFIG is used to query the system-wide configuration set

       ^^^^^^^^^^^^^^^^^^

This should be SNP_GET_EXT_CONFIG.


-Dov

> +through the SNP_SET_EXT_CONFIG.
> +
>  3. SEV-SNP CPUID Enforcement
>  ============================
>  
