Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23064B0C01
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 12:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240665AbiBJLNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 06:13:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240640AbiBJLNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 06:13:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9EACCA;
        Thu, 10 Feb 2022 03:13:47 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21A9RwGA025128;
        Thu, 10 Feb 2022 11:13:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=I0qEQmOq3NIOOeInTMv0rhTkCQgtkQo7LY1Gh4rd3J8=;
 b=EncrcrEUeh0SiVr8ByuZ2SdPDkciRdh875gzIv/cQeuuWyLexiTMKEAczrpOw33Db3dC
 BB6RsCtJXCBZcz6hiRmCZV7cm790bAZPrdWBpBooWTR9J1ELnQdLU7swxB9m8g6zVwEu
 E4LxJS9pEzIgIxT3wWs2CIXexaNqx01gM8WPzROmsGy9hYn3vfT0SuTtv0GQ1M6kha6I
 fzC4RXEd2/LTKS56oQFu9CTjRZtbVIt1tP0Yhda1p5d2xUhpo4rxoWQ/ZmDxVZCeH9Eo
 w7AMk3X8nfh3moY0OkoFqKdb5JC4kTiNhPow7AcyCwy64u21gFfKMwbM2mEMA2oUjLdr ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e503qa91f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 11:13:47 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21AAtr5h011882;
        Thu, 10 Feb 2022 11:13:46 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e503qa913-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 11:13:46 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21AB8WLb004121;
        Thu, 10 Feb 2022 11:13:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gv9y6rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 11:13:44 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21ABDf5t46072134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 11:13:41 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C22211C052;
        Thu, 10 Feb 2022 11:13:41 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26F0111C050;
        Thu, 10 Feb 2022 11:13:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.149])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Feb 2022 11:13:41 +0000 (GMT)
Date:   Thu, 10 Feb 2022 12:13:38 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: MAINTAINERS: promote Claudio Imbrenda
Message-ID: <20220210121338.4ce8c071@p-imbrenda>
In-Reply-To: <20220210085310.26388-1-borntraeger@linux.ibm.com>
References: <20220210085310.26388-1-borntraeger@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bkRty1MNcdKNR-pHouvLndYFvsr65VaK
X-Proofpoint-ORIG-GUID: YzF9idVAhblZBuh7a-9bG0SZF8vS4XK1
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_03,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxlogscore=921 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202100061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Feb 2022 09:53:10 +0100
Christian Borntraeger <borntraeger@linux.ibm.com> wrote:

> Claudio has volunteered to be more involved in the maintainership of
> s390 KVM.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f41088418aae..cde32aebb6ef 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10548,8 +10548,8 @@ F:	arch/riscv/kvm/
>  KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
>  M:	Christian Borntraeger <borntraeger@linux.ibm.com>
>  M:	Janosch Frank <frankja@linux.ibm.com>
> +M:	Claudio Imbrenda <imbrenda@linux.ibm.com>
>  R:	David Hildenbrand <david@redhat.com>
> -R:	Claudio Imbrenda <imbrenda@linux.ibm.com>
>  L:	kvm@vger.kernel.org
>  S:	Supported
>  W:	http://www.ibm.com/developerworks/linux/linux390/

