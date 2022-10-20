Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B08605A5A
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 10:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiJTI5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 04:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJTI5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 04:57:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD643193ECA
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 01:57:47 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K8hHEC010850
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:57:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=oMEGHWSY3PcPw8QUrgFQwE8TSqVgPI9uIGrpoPwHR+c=;
 b=q7C+b25CtJQNtDbbYBCZdW9pW8a9ipr73d3v9Zd4oRrZk5cXSrWSlkmYLAkjUZB+O6Jz
 wkNX8+kIDwisqocKmLO5V2KTBlsxQOAO8Q6DJ3n0faHc6d22i+2/n0tuCqNbGRH6Uy47
 0lvK6CK6eLaV4B+yeN8nAxfAOU3Y0+kDvK+dwq3Bj9VYQrDuqIFKOToazG1bDynTTmJo
 cE6aPgBWGDn/GNosuixRqSQ4Xa5WJhC+Jp4grIRncS4qh4PI48pIKlf+cwIPjkT//LZd
 yIE/IR0+bg2fn02HaZsjnbFzYln1UmQJ1j2eVSgUwRkKLpPBctlRh2/CDzeHUvbyht80 Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb32hrbwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:57:46 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K8vkb0028412
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:57:46 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb32hrbw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 08:57:46 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K8onJL017402;
        Thu, 20 Oct 2022 08:57:44 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3k99fn3y4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 08:57:44 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K8vfiK51839402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 08:57:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A960A405F;
        Thu, 20 Oct 2022 08:57:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AC32A405C;
        Thu, 20 Oct 2022 08:57:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 08:57:41 +0000 (GMT)
Date:   Thu, 20 Oct 2022 10:57:38 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/2] lib: s390x: terminate if PGM
 interrupt in interrupt handler
Message-ID: <20221020105738.2af4ece0@p-imbrenda>
In-Reply-To: <166625268562.6247.14921568293025628326@t14-nrb>
References: <20221018140951.127093-1-imbrenda@linux.ibm.com>
        <20221018140951.127093-2-imbrenda@linux.ibm.com>
        <166616486603.37435.2225106614844458657@t14-nrb>
        <20221019115128.2a8cbf13@p-imbrenda>
        <166625268562.6247.14921568293025628326@t14-nrb>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T72q18peE6TL_R-PNVIX7lXP8Zb_sawq
X-Proofpoint-ORIG-GUID: Jq__OVV2nrSHZHfI0zqP6GrsVLR5F9uM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 adultscore=0 phishscore=0 clxscore=1015 mlxlogscore=702
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Oct 2022 09:58:05 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Claudio Imbrenda (2022-10-19 11:51:28)
> [...]
> > I was thinking that we set pgm_int_expected = false so we would catch a
> > wild program interrupt there, but in hindsight maybe it's better to set
> > in_interrupt_handler = true there so we can abort immediately  
> 
> Oh right I missed that. I think how it is right now is nicer because we will get a nice message on the console, right?

which will generate more interrupts

@Janosch do you think it's better with or without setting
in_interrupt_handler in the pgm interrupt handler?

> 
> In this case:
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

