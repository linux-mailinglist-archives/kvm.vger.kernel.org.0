Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0BE51D6BA
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 13:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391395AbiEFLhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 07:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391378AbiEFLhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 07:37:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C1062A0A;
        Fri,  6 May 2022 04:33:40 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246BEGaT028215;
        Fri, 6 May 2022 11:33:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=j164G7uED0eN6dY0LEDq4vcZtaflgdo9SaomxX5XB7k=;
 b=I27eNDNzVBtX0FVxDzqDzbYQ9w3Ylzeah7Ztuj23vqAgcxZkWDL1GW5G4eIibNimivSq
 6pOAc6ZE/s5eFfpxRHIw4rQQSyWi+DbpFBLLWvBwGNJi8JOm3FvcjK2Bms4LgklWuPCc
 eJoPc+7wyk48u07oQv39k8RjjV4YzXB0mvkp1YnzV/YJL0O0ZSxhjSo/xbG6fix5n3Xx
 gFjOV4QDZHkhFQKs/IC+Se5kGb1GGkDs1+Vqg5Q496CWWswY8eq9ivnBsfsz26DJqUlj
 mAQJWItHaQrt4J9LMog7hcsOpxC9VpIMOup7PjNmGqT1WSLhXCEeBdQtIAhCSYKjMf6J 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw2m78a2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 11:33:39 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 246BREc2013207;
        Fri, 6 May 2022 11:33:39 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw2m78a25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 11:33:38 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246BSgj1011907;
        Fri, 6 May 2022 11:33:37 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3fvnaqgv47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 11:33:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 246BXY6J45089080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 11:33:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB8794C044;
        Fri,  6 May 2022 11:33:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A9A74C052;
        Fri,  6 May 2022 11:33:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.58])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 11:33:33 +0000 (GMT)
Date:   Fri, 6 May 2022 13:33:26 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v10 02/19] KVM: s390: pv: handle secure storage
 violations for protected guests
Message-ID: <20220506133326.09e9a887@p-imbrenda>
In-Reply-To: <9d79d8c9-9d3f-de6e-e910-62549fc2ac5d@redhat.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
        <20220414080311.1084834-3-imbrenda@linux.ibm.com>
        <9d79d8c9-9d3f-de6e-e910-62549fc2ac5d@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _fupn4z-WVOrs5Ne7ZpektPGch_-Q_TD
X-Proofpoint-GUID: gxJy_8sUn4t94Lkv9s_9oo7nG50zbHa4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_04,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 5 May 2022 19:10:39 +0200
Thomas Huth <thuth@redhat.com> wrote:

> On 14/04/2022 10.02, Claudio Imbrenda wrote:
> > With upcoming patches, protected guests will be able to trigger secure
> > storage violations in normal operation.
> > 
> > A secure storage violation is triggered when a protected guest tries to
> > access secure memory that has been mapped erroneously, or that belongs
> > to a different protected guest or to the ultravisor.
> > 
> > With upcoming patches, protected guests will be able to trigger secure
> > storage violations in normal operation.  
> 
> You've already used this sentence as 1st sentence of the patch description. 
> Looks weird to read it again. Maybe scratch the 1st sentence?

oops!

> 
> > This happens for example if a
> > protected guest is rebooted with lazy destroy enabled and the new guest
> > is also protected.
> > 
> > When the new protected guest touches pages that have not yet been
> > destroyed, and thus are accounted to the previous protected guest, a
> > secure storage violation is raised.
> > 
> > This patch adds handling of secure storage violations for protected
> > guests.
> > 
> > This exception is handled by first trying to destroy the page, because
> > it is expected to belong to a defunct protected guest where a destroy
> > should be possible. If that fails, a normal export of the page is
> > attempted.
>  >
> > Therefore, pages that trigger the exception will be made non-secure
> > before attempting to use them again for a different secure guest.  
> 
> I'm an complete ignorant here, but isn't this somewhat dangerous? Could it 
> happen that a VM could destroy/export the pages of another secure guest that 
> way?

this is a good question, perhaps I should add a comment explaining that
the destroy page UVC will only work on protected VMs with no CPUs.

Exporting instead is not an issue, if/when the page is needed, it will
get imported again. Unless some things went really wrong, but that can
only happen in case of a bug in the hypervisor.

> 
>   Thomas
> 

