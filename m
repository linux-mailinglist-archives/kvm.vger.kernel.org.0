Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FF5528C5A
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 19:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344451AbiEPRvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 13:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344530AbiEPRu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 13:50:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B6FA44A;
        Mon, 16 May 2022 10:50:54 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GFCIU6019460;
        Mon, 16 May 2022 17:50:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=A4jX2fNiMfHRhahwL/lYs1a9gU+e3VH5JPb9+D5ghcw=;
 b=PPo9CjfMuiXdIsXHhy5z8rtD/QrN2K1snGpcLZXMbkD1s/9OiRNe8UYAuRkSs9iX9OBV
 yv6qIv5nNhfYSCXxoNIlNI/H+D7cm0BRGo4QTJeNfOxVZF4ySC5yIxlL2XEZRjh2rMR4
 vqevcFYDSEM8u308Qi/S8COc9ioVOWnJy7Bjrd5FnLz6JRIHCGPg+mffoZYc0J2eROCx
 Wwq0EZ0PhghYH7Upf8jrecaWgGapLoFPRpiLV1MpW+fgMNC9dejRNEgKyZwSLL9tS4V4
 iv20KViGLDvrsmjZncIMVPxcect97lAjPYStIQm72GZYdtZyTNLyBdeAGMPM01gm9eV/ 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3s1v398n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 17:50:52 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GHn7aM005435;
        Mon, 16 May 2022 17:50:52 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3s1v398e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 17:50:52 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GHXj62028321;
        Mon, 16 May 2022 17:50:51 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma03dal.us.ibm.com with ESMTP id 3g242a3qym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 17:50:51 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GHonro24969688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 17:50:49 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1CAC78066;
        Mon, 16 May 2022 17:50:49 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E340D78068;
        Mon, 16 May 2022 17:50:48 +0000 (GMT)
Received: from [9.60.75.219] (unknown [9.60.75.219])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 17:50:48 +0000 (GMT)
Message-ID: <6720e18e-0638-7f2f-533e-beca8a990404@linux.ibm.com>
Date:   Mon, 16 May 2022 13:50:48 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v19 05/20] s390/vfio-ap: refresh guest's APCB by filtering
 AP resources assigned to mdev
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-6-akrowiak@linux.ibm.com>
 <fc760c00-0559-68d8-fd2d-f29e014a6685@linux.ibm.com>
 <62668577-bf0c-eda5-56a0-9ca56e5f9ce6@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <62668577-bf0c-eda5-56a0-9ca56e5f9ce6@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Bt_VE0whdrn5UjRK6f5Nh0DapcJfUwgm
X-Proofpoint-ORIG-GUID: SbhiqgXmQxCX-vrqxP77Y69lnlIBg4-u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160096
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/16/22 13:13, Tony Krowiak wrote:
> 
> 
> On 5/16/22 12:36 PM, Jason J. Herne wrote:
>> On 4/4/22 18:10, Tony Krowiak wrote:
>>> |@@ -1306,8 +1392,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev 
>>> *matrix_mdev, kvm_get_kvm(kvm); matrix_mdev->kvm = kvm; - 
>>> memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix, - sizeof(struct ap_matrix)); 
>>> kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm, 
>>> matrix_mdev->shadow_apcb.aqm, matrix_mdev->shadow_apcb.adm);|
>>
>> This looks like an unrelated change. Does this snippet really belong to this patch?
> 
> It's kind of hard to tell which snippet you are talking about without the patch context, 
> but I assume you are referring to the removal of the memcpy statement in the 
> vfio_ap_mdev_set_kvm() function in which case this snippet belongs with this patch.
> 
> This patch introduces a function that filters the contents of the matrix_mdev->matrix to 
> ensure that the matrix_mdev->shadow_apcb contains only queues that are bound to the 
> vfio_ap device driver. The filtering function is called whenever an adapter, domain or 
> control domain is assigned or unassigned, so it is no longer necessary to copy the 
> contents of matrix_mdev->matrix into matrix_mdev->shadow_apcb before setting the masks in 
> the guest; that will have already been done by the filter function.
> 
> 

I was apparently a little overzealous with my trimming. Yes, you are correct. Thanks for
the explanation.

Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>


-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
