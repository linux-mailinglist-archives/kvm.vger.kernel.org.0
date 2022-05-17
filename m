Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5FA52A8A9
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351269AbiEQQzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350665AbiEQQyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:54:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38474F459;
        Tue, 17 May 2022 09:54:54 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HGhI4M004270;
        Tue, 17 May 2022 16:54:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=oQvjd7pZ9onoJw6RfgLEKpnF6d/rORqhVPyf4PVYGnw=;
 b=Mb9VLKEUbt0fNTOAOqFAa1gJW7K2P/u+7H8OmmOSiCAQbgpzuHrb3md/Ai/6x621Bq5b
 7ETDWsjdFfk28+lRcuSc+yeDztvYFFW4XOMK0eWLndFb5eB3Sm7HuJE9YjlLH7SkROq6
 vbkvmzr8Xn3xVm7CY1AOOlX0fiyIxj5mAErfvu1B9mD1v2BShILeppe0FXPeYWcCB6Ld
 PzZR7FMEEMwer6JMf8gQ5Pzv3ypKt0PhSUXdjbRpfbWjrHlAf53AJudlLUU768TyhxVv
 8EQtWP9Y9aCoYQWRO7OcQopPMWw4Yv7phgVlxNyUISk4c1Xi13EmzqG0jA9hJSeAHPfc 1w== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4ffjr862-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:54:53 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HGmq7l017342;
        Tue, 17 May 2022 16:54:52 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3g2429chsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:54:51 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HGsnxF43254064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 16:54:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE2A3AE053;
        Tue, 17 May 2022 16:54:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE9E1AE045;
        Tue, 17 May 2022 16:54:48 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 16:54:48 +0000 (GMT)
Date:   Tue, 17 May 2022 18:47:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v6 11/11] Documentation/virt/kvm/api.rst: Explain rc/rrc
 delivery
Message-ID: <20220517184725.7e1409ac@p-imbrenda>
In-Reply-To: <20220517163629.3443-12-frankja@linux.ibm.com>
References: <20220517163629.3443-1-frankja@linux.ibm.com>
        <20220517163629.3443-12-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6gtRVkc8dczFDG3cNXDHBwMMfSbXhp4R
X-Proofpoint-ORIG-GUID: 6gtRVkc8dczFDG3cNXDHBwMMfSbXhp4R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 spamscore=0 impostorscore=0 clxscore=1015
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 May 2022 16:36:29 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's explain in which situations the rc/rrc will set in struct
> kvm_pv_cmd so it's clear that the struct members should be set to
> 0. rc/rrc are independent of the IOCTL return code.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  Documentation/virt/kvm/api.rst | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 06d1b717b032..7b0993e4106f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5067,6 +5067,14 @@ into ESA mode. This reset is a superset of the initial reset.
>  	__u32 reserved[3];
>    };
>  
> +**Ultravisor return codes**
> +The Ultravisor return (reason) codes are provided by the kernel if a
> +Ultravisor call has been executed to achieve the results expected by
> +the command. Therefore they are independent of the IOCTL return
> +code. If KVM changes `rc`, its value will always be greater than 0
> +hence setting it to 0 before issuing a PV command is advised to be
> +able to detect a change of `rc`.
> +
>  **cmd values:**
>  
>  KVM_PV_ENABLE

