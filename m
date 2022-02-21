Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA1D4BDF30
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379879AbiBUQGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:06:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237970AbiBUQGq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:06:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8371E2716C;
        Mon, 21 Feb 2022 08:06:23 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LEf0ic030799;
        Mon, 21 Feb 2022 16:06:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pdWCOxWyY8ZelYPiLVKLy5St6GKQA/W6MmoXe97S008=;
 b=D56nkLPBh7motxT1hPFVkmdCOnw2cXhHiO4+SZpV/IAe4B03n5P/GIqYSg0SVDip7UjP
 1wJKokx2TtiEIbf9COQ9BtiDxNcLwTFm+YQkmE2DSJgixNvkZu6Y5Iy74ezdc+2XF1Zp
 Xw+WDsIybrgZ9k11NAzBdBlRjQS2lnDyRewET4P+Ys2XW2ywQ3U86E4U0+y8E66w6EaU
 RPAI8ACXRmFfAGg4X05m036FtQcYHes2hO5j31BAchD0s10AoAiYXbcKgZrMCPYwdLbF
 xq3XH+KGQhZ46qdwCxIqP7+YHvFeX/Ab+soHd2DQTge1/48Gn7anIhLsIg2Ev2QYJGjf gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ec0eu95r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 16:06:22 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21LEoOPS032474;
        Mon, 21 Feb 2022 16:06:22 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ec0eu95q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 16:06:22 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LG4mdb025637;
        Mon, 21 Feb 2022 16:06:19 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ear68u2qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 16:06:19 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LG6Gfi54526246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 16:06:16 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AECB52057;
        Mon, 21 Feb 2022 16:06:16 +0000 (GMT)
Received: from [9.171.10.246] (unknown [9.171.10.246])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 92BBC5204F;
        Mon, 21 Feb 2022 16:06:15 +0000 (GMT)
Message-ID: <feca1bb9-f6d6-e8b3-1688-bf1dcc91125e@linux.ibm.com>
Date:   Mon, 21 Feb 2022 17:06:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: s390: Clarify key argument for MEM_OP in api docs
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
References: <20220211182215.2730017-10-scgl@linux.ibm.com>
 <20220221143657.3712481-1-scgl@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220221143657.3712481-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z1yQGkVMLxeBIfGRETJLfJo4uhAflxeq
X-Proofpoint-ORIG-GUID: 9FhapYrVAw1OURms_XsYD-f9AzFylgFO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_07,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 spamscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202210095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 21.02.22 um 15:36 schrieb Janis Schoetterl-Glausch:
> Clarify that the key argument represents the access key, not the whole
> storage key.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>   Documentation/virt/kvm/api.rst | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 48f23bb80d7f..622667cc87ef 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -3763,7 +3763,7 @@ KVM_S390_MEMOP_F_INJECT_EXCEPTION is set.
>   
>   If the KVM_S390_MEMOP_F_SKEY_PROTECTION flag is set, storage key
>   protection is also in effect and may cause exceptions if accesses are
> -prohibited given the access key passed in "key".
> +prohibited given the access key designated by "key"; the valid range is 0..15.
>   KVM_S390_MEMOP_F_SKEY_PROTECTION is available if KVM_CAP_S390_MEM_OP_EXTENSION
>   is > 0.
>   
> 
> base-commit: af33593d63a403287b8a6edd217e854a3571938b

I have already queued the patches. Will add this on top as a fixup patch.
