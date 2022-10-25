Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B62260D186
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 18:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbiJYQVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 12:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbiJYQUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 12:20:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83AF165C92;
        Tue, 25 Oct 2022 09:20:49 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PF4D3k002076;
        Tue, 25 Oct 2022 16:20:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Iulm6ID2VpcNdrVzNPzJPmmwv9Rv9yKhaHWBitwW0jg=;
 b=WeMDiMAka/EuTBDF6cRdmbDEnl8nANTEBF4CBOdXX7Dhg1oregkLIJ2hpajEetNuQm1P
 4Su+xwXVKveBBUwlwThRogv2hpKpCnaWQJyfoxgECIPxXqzl0DktlMflzfod+Uy8L85g
 RnQ8hTAacT7pJAaHUrTiXcWsCvMfIjQ9awDX0QmMnFOIE/NSfXmjA4yv0qtMmLhnTgHc
 D4j4qzJ6ZZyl3Ch6IJdWoGG+pRe9ZijqN/Q3WJMKWglm6QupbQAS7rQ2hLSTgzu/Gszt
 RR0+CYleQNbWi2P6we6pgyNrHnwwN+53qRb3lg3ut0UTmHzo/sy0DR1lYLOE+9vTwdJh Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3keddv5pd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 16:20:48 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PFx6vU001445;
        Tue, 25 Oct 2022 16:20:47 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3keddv5pbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 16:20:47 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PG6Aj3001554;
        Tue, 25 Oct 2022 16:20:45 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3kc8594tdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 16:20:44 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PGLGHI52756874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 16:21:16 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB30352050;
        Tue, 25 Oct 2022 16:20:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.13.249])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 1DCCB5204E;
        Tue, 25 Oct 2022 16:20:41 +0000 (GMT)
Date:   Tue, 25 Oct 2022 18:20:39 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        svens@linux.ibm.com
Subject: Re: [PATCH v2 1/1] KVM: s390: vsie: clarifications on setting the
 APCB
Message-ID: <20221025182039.6dc82fbf@p-imbrenda>
In-Reply-To: <0117e263-2856-b2fd-1e61-59b21e5da2e5@linux.ibm.com>
References: <20221025091319.37110-1-pmorel@linux.ibm.com>
        <20221025091319.37110-2-pmorel@linux.ibm.com>
        <e9a237d7-3a34-11c8-1c5b-1a3c14e8cfb0@redhat.com>
        <0117e263-2856-b2fd-1e61-59b21e5da2e5@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: geMPvLIUK-Kykafa3OpyFm8j2gpYD8kT
X-Proofpoint-ORIG-GUID: NGSjiZc1l7YdYnPCUOSZXJzNwHooY1mr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_09,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=687 phishscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Oct 2022 15:17:36 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 10/25/22 11:30, David Hildenbrand wrote:
> > On 25.10.22 11:13, Pierre Morel wrote:  
> >> The APCB is part of the CRYCB.
> >> The calculation of the APCB origin can be done by adding
> >> the APCB offset to the CRYCB origin.
> >>
> >> Current code makes confusing transformations, converting
> >> the CRYCB origin to a pointer to calculate the APCB origin.
> >>  
> > 
> > 
> > While at it, can we rename "crycb_o" to "crycb_gpa" and "apcb_o" to 
> > "apcb_gpa".
> > 
> > These are not pointers but guest physical addresses.
> >   
> 
> I can do that.
> the _o came from the name in the documentation "origin"
> but gpa is more obvious.
> 

with that fixed: 

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
