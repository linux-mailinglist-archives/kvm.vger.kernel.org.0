Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1D859993E
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 11:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347808AbiHSJvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 05:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346395AbiHSJvD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 05:51:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16352EF001;
        Fri, 19 Aug 2022 02:51:02 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27J9RhCK005956;
        Fri, 19 Aug 2022 09:51:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/n+0HvGmT1pfTamPIFhgrgyDHjxBz4Xfo3FQmH1h9H8=;
 b=eN0zHAAQ99HxCC1A+SJ3wtp/Do91HjNWhFYkjabqlvvg/BVgk/2Tr/3N51Xt/Zgbtddm
 7o+wjObv5HZ/5uPk1W8GqVGjMRW2k0saGD7lDn0KatZJRQJ5/0d/t1XYgIeAjjvYVTDY
 gga0tTeOt//8Zr/IdujSNhVUek54lSTXRgPJcSHhyh3pH+CerzNCaCHdLKfiaVKAVL6g
 JtwN/rNM1IVG632TLGWUVxFHp/Dt5hV/+eNnhuTsIEo/mqJ3oRV22pzgtz2GkO43fevA
 8WtVOrAkGoIUz6vu2WCREc6uU3bIp5DtAL+tPDUlZWTcRqLK/vXdpyKK/JWqGFxVcgYC Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j27whrk26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 09:51:01 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27J9jC6g014549;
        Fri, 19 Aug 2022 09:51:01 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j27whrk1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 09:51:01 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27J9Kpnb011979;
        Fri, 19 Aug 2022 09:50:58 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3hx3k8y288-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Aug 2022 09:50:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27J9pE0036635114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Aug 2022 09:51:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D35CAE051;
        Fri, 19 Aug 2022 09:50:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D93D7AE045;
        Fri, 19 Aug 2022 09:50:54 +0000 (GMT)
Received: from [9.145.49.220] (unknown [9.145.49.220])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Aug 2022 09:50:54 +0000 (GMT)
Message-ID: <99a49638-1604-962e-9010-1b57111d3132@linux.ibm.com>
Date:   Fri, 19 Aug 2022 11:50:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
References: <20220810125625.45295-1-imbrenda@linux.ibm.com>
 <20220810125625.45295-5-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v13 4/6] KVM: s390: pv: avoid export before import if
 possible
In-Reply-To: <20220810125625.45295-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NNgj39bwebWjNUdU7YYEarOHQPvFevST
X-Proofpoint-ORIG-GUID: qPlsnErocGN7hRNExndp0u-nGtAuWj4g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_04,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208190037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/22 14:56, Claudio Imbrenda wrote:
> If the appropriate UV feature bit is set, there is no need to perform
> an export before import.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   arch/s390/kernel/uv.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index f9810d2a267c..b455646c8d74 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -255,6 +255,8 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
>    */
>   static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
>   {
The misc feature indicates that the UV will automatically transfer 
ownership from one protected VM to another when importing a shared page.


Other than that:
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>


> +	if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications))
> +		return false;
>   	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
>   		return false;
>   	return atomic_read(&mm->context.protected_count) > 1;

