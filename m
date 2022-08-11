Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02B858F938
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 10:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiHKIhn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 04:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234541AbiHKIhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 04:37:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB3E792D8
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 01:37:34 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27B78vFp031409
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 08:37:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=XZziXSjbTgx8/Y9VR60kOYqu8SSTCrhR/id5zKT+ctw=;
 b=RC4U+E7tra/XD4vrGQvjeDMu/j430ZjEzRUkPhdJp4LjxqXqcCbDjUFyQ0k7FWb0IPTn
 Cm53bM09r0+sCpdy7BRjJYdvnzx5XIKDpNnJBtp7sbbU8YMIelYnOvezqNKmdyTlRZkQ
 UPSejwgxBDVY/4IaoFz3ahsv28T6xCfE4RLreKdP/AxK/O8i2uXgaZ0MPSrkfd4vN2gy
 Qg8TGuZn6ahrJZrDTmD4hRoCM0tpExH5KFfVbJrtBKKZNBiTfr5s4RwFO3l+/1p3SMWq
 atcP3D+SZ71YmF5tMm7+vtnF5AvDRtBxF5yCIEhgeaYfojTZXUs56NkBgNQ54ajKtCUW xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hvvtqu2er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 08:37:33 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27B7925C033507
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 08:37:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hvvtqu2dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 08:37:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27B8bVRB011700;
        Thu, 11 Aug 2022 08:37:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3huwvg1sm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 08:37:31 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27B8YuKh31654390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 08:34:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C0C4AE051;
        Thu, 11 Aug 2022 08:37:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C424AE045;
        Thu, 11 Aug 2022 08:37:28 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.154])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Aug 2022 08:37:28 +0000 (GMT)
Date:   Thu, 11 Aug 2022 10:37:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 3/4] s390x: add extint loop test
Message-ID: <20220811103725.329e0016@p-imbrenda>
In-Reply-To: <166020447794.24812.2478143576932288604@localhost.localdomain>
References: <20220722060043.733796-1-nrb@linux.ibm.com>
        <20220722060043.733796-4-nrb@linux.ibm.com>
        <20220810120822.51ead12d@p-imbrenda>
        <166013456744.24812.12686537606143025741@localhost.localdomain>
        <20220810151302.67aa3d3c@p-imbrenda>
        <166020447794.24812.2478143576932288604@localhost.localdomain>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cI47OggdujH-M41PWegb7EMUoH9s-F1a
X-Proofpoint-GUID: dXYDhgaPUGiWFUyq43bPphVt4Qa7TjGx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_03,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 mlxlogscore=774 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110023
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Aug 2022 09:54:37 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Claudio Imbrenda (2022-08-10 15:13:02)
> [...]
> > just add a comment to explain that  
> 
> Yes makes sense, thanks. I came up with this:
> 
> /*
>  * When the interrupt loop occurs, this instruction will never be
>  * executed.
>  * In case the loop isn't triggered return to pgm_old_psw so we can fail
>  * fast and don't have to rely on the kvm-unit-tests timeout.
>  */

lgtm
