Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49188538567
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 17:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240988AbiE3Pui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 11:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242301AbiE3PuE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 11:50:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD1A6B7CE;
        Mon, 30 May 2022 08:13:49 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24UFAFPq007497;
        Mon, 30 May 2022 15:13:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SDuobairNOThcjzkW4XQAfO5XpvRpmokQlYT4Ui8av4=;
 b=E1mbltHf+7j+Zi0eArp24YpfKmNtxCMWNzaABqZO3mdxuA0VJ904OhEnHJodD1SG0rD+
 Ssd+qUchy3b7axMqjFO1++h/y5eZv+/CQo+Cc7smngWe2P6PaKlzhXDL0yBInvTC6GAY
 CFU+2+c4aYtESF6h4l4F8cZtzit6SbZkQMGv3jTyYiQ1QO/wiEJBMBLYyv2wFpZFSPa8
 pFpzYtvt8YX209fkrcdYKqGgoScP7mfQrTFTg0aTtsHU+EqhysSanjE78a6qufmywUL9
 k7R81Xwig9/hAReze9UB9fo35DJ13Ygms9jv4BwG9Thjjf9xQVsOCtEeDfIwOHZZ9Z9y nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcytk0m3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 15:13:48 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24UFC5d8012392;
        Mon, 30 May 2022 15:13:47 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcytk0m35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 15:13:47 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24UFDGGj005773;
        Mon, 30 May 2022 15:13:46 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3gbbynjwqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 15:13:45 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24UFDhNa40042784
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 15:13:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DDD95204F;
        Mon, 30 May 2022 15:13:43 +0000 (GMT)
Received: from [9.171.2.176] (unknown [9.171.2.176])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B824F5204E;
        Mon, 30 May 2022 15:13:42 +0000 (GMT)
Message-ID: <1e70fb20-dab5-214e-dae3-5949c8b59945@linux.ibm.com>
Date:   Mon, 30 May 2022 17:13:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/1] MAINTAINERS: Update s390 virtio-ccw
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20220525144028.2714489-1-farman@linux.ibm.com>
 <20220525144028.2714489-2-farman@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220525144028.2714489-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dIUA8oIGj35Pbtc278YJoTVTdaHtV3tW
X-Proofpoint-ORIG-GUID: LOvQ2eSHWdiBx4j02xe3Ef4b2jrQZmDL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_06,2022-05-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0
 adultscore=0 impostorscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205300079
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 25.05.22 um 16:40 schrieb Eric Farman:
> Add myself to the kernel side of virtio-ccw
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6618e9b91b6c..1d2c6537b834 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20933,6 +20933,7 @@ F:	include/uapi/linux/virtio_crypto.h
>   VIRTIO DRIVERS FOR S390
>   M:	Cornelia Huck <cohuck@redhat.com>
>   M:	Halil Pasic <pasic@linux.ibm.com>
> +M:	Eric Farman <farman@linux.ibm.com>
>   L:	linux-s390@vger.kernel.org
>   L:	virtualization@lists.linux-foundation.org
>   L:	kvm@vger.kernel.org

Thanks applied. Will either queue via the kvm or s390 tree.
