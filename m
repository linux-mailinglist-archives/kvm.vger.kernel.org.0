Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1175368EF
	for <lists+kvm@lfdr.de>; Sat, 28 May 2022 00:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354877AbiE0WmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 18:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiE0WmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 18:42:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5DB5B8A7;
        Fri, 27 May 2022 15:42:03 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24RM0k7T003448;
        Fri, 27 May 2022 22:42:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=pxidKfGt+g7zv2vqG5JLl2ETdA1ZwJVfb57zs1kpF7M=;
 b=XA35w4Nit5sOEMEYFHWyXNVQ2DppWETJTVbqYVHYS8/sEt1dEeXEaei3TgRYD6dqompZ
 vLsOLdphs2B4QYerX5UjJn/zFMHTMHkfGeeUDZ77fYfwyvsaRWWkTHQyOiQ1jvop7SjB
 GarsyRmLTaIoSG1TFkgd10TD8F+izEFBQ896XhfiHbLnvHZEZZWEE43zE/pru74qbC36
 KiOwVwfGUukP4Y7QC4i25Io4Nh3J8bFcSTgU0IO9mZ9jk5Nhj8iU6ZIs6Cafeq9FUwB7
 BVJPDLU2vTkAi9V8duZLlLxnf3LAnNml2TQYurX7YARItwc8if7f2XMfV3dfhto3oCr0 Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gb72crjyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 May 2022 22:42:02 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24RMaxQ5024984;
        Fri, 27 May 2022 22:42:01 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gb72crjya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 May 2022 22:42:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24RMaO5a031234;
        Fri, 27 May 2022 22:42:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3gb61xr2q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 May 2022 22:41:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24RMfukD27918674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 May 2022 22:41:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6E4B42042;
        Fri, 27 May 2022 22:41:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4880E42041;
        Fri, 27 May 2022 22:41:56 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.67.241])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 27 May 2022 22:41:56 +0000 (GMT)
Date:   Sat, 28 May 2022 00:41:53 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] MAINTAINERS: Update s390 virtio-ccw
Message-ID: <20220528004153.2646d6e0.pasic@linux.ibm.com>
In-Reply-To: <20220525144028.2714489-2-farman@linux.ibm.com>
References: <20220525144028.2714489-1-farman@linux.ibm.com>
        <20220525144028.2714489-2-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bLocytusjxht59ujZCGENDjs3OQLiFum
X-Proofpoint-GUID: 5AiYX3XK5QcQFBbY-0MqwBljtbcvEJ77
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-27_07,2022-05-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 bulkscore=0 clxscore=1011 mlxlogscore=999 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205270109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 May 2022 16:40:28 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Add myself to the kernel side of virtio-ccw
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Acked-by: Halil Pasic <pasic@linux.ibm.com>

Thanks for joining the team!

:) 

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6618e9b91b6c..1d2c6537b834 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20933,6 +20933,7 @@ F:	include/uapi/linux/virtio_crypto.h
>  VIRTIO DRIVERS FOR S390
>  M:	Cornelia Huck <cohuck@redhat.com>
>  M:	Halil Pasic <pasic@linux.ibm.com>
> +M:	Eric Farman <farman@linux.ibm.com>
>  L:	linux-s390@vger.kernel.org
>  L:	virtualization@lists.linux-foundation.org
>  L:	kvm@vger.kernel.org

