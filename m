Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52734E790C
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 17:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245613AbiCYQkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 12:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245582AbiCYQkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 12:40:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC74523BD2;
        Fri, 25 Mar 2022 09:38:35 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22PFJl6l006066;
        Fri, 25 Mar 2022 16:38:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=13SSTdWe3Z8ZLyg4huZnZSLnGAHEoVVg+j9naH3JkqE=;
 b=iXWl+L5hKLf43oBjLlltaficUvl3DYhj+dECKqwMnioX3sNn9FVOdI0orkBITi3fpKSZ
 Ziwf/V3g4rt0pTVGkHjRJEFcH8MBfYxtPnMDAYRrRxidx9efkQy5KuUKLISY673S4euW
 LHAZD55z5wZkGUqvKUO3R3UmfYDcDXl56iX4dySI/EI8y/ENRiSroJ2BMc3NyM+TXQKK
 G3g7v9gy2AWtcBDkJg3f5sV21PMM8JI6/uUn8Ef8BlJtbIn4PM/1LzrdEkBJh541/fWc
 N4BNR0Kb20hyU5oRMnGk83IE6dzWrDa/6XCOfGFL+XLuZVw9KjFTWgLaimvfxAwVvH13 cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0rgtgex6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 16:38:34 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22PGR4oX030856;
        Fri, 25 Mar 2022 16:38:34 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0rgtgewq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 16:38:34 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22PGSJ8N005698;
        Fri, 25 Mar 2022 16:38:32 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ew6t95p2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 16:38:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22PGcSsF28639492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 16:38:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71DDE4C046;
        Fri, 25 Mar 2022 16:38:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08E6C4C040;
        Fri, 25 Mar 2022 16:38:28 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.92])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Mar 2022 16:38:27 +0000 (GMT)
Date:   Fri, 25 Mar 2022 17:38:25 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 3/9] s390x: gs: move to new header
 file
Message-ID: <20220325173825.2df90f51@p-imbrenda>
In-Reply-To: <34d7549b-40c0-a010-3a05-2adbe5f9c41d@linux.ibm.com>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
        <20220323170325.220848-4-nrb@linux.ibm.com>
        <YjytK7iW7ucw/Gwj@osiris>
        <a2870c6b-6b2a-0a81-435e-ec0f472697c6@linux.ibm.com>
        <20220325153048.48306e40@p-imbrenda>
        <34d7549b-40c0-a010-3a05-2adbe5f9c41d@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Us7CWJbYuQ8wtapvr7f2tJbrcKmfi-4Y
X-Proofpoint-GUID: AoV9ocPcgz0ZIHNVVTbT0EjJ933psDce
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_05,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=916
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203250090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Mar 2022 16:07:47 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 3/25/22 15:30, Claudio Imbrenda wrote:
> > On Fri, 25 Mar 2022 08:29:11 +0100
> > Janosch Frank <frankja@linux.ibm.com> wrote:
> >   
> >> On 3/24/22 18:40, Heiko Carstens wrote:  
> >>> On Wed, Mar 23, 2022 at 06:03:19PM +0100, Nico Boehr wrote:
> >>> ...  
> >>>> +static inline unsigned long load_guarded(unsigned long *p)
> >>>> +{
> >>>> +	unsigned long v;
> >>>> +
> >>>> +	asm(".insn rxy,0xe3000000004c, %0,%1"
> >>>> +	    : "=d" (v)
> >>>> +	    : "m" (*p)
> >>>> +	    : "r14", "memory");
> >>>> +	return v;
> >>>> +}  
> >>>
> >>> It was like that before, but why is r14 within the clobber list?
> >>> That doesn't make sense.  
> >>
> >> r14 is changed in the gs handler of the gs test which is executed if the
> >> "guarded" part of the load takes place.  
> > 
> > I will add a comment explaining that when picking the patch  
> 
> Do we need load_guarded() in this new header?
> The load/store_gscb() functions have potential to be shared across tests 
> but the lg doesn't need to be executed, no?
> 
> We could opt to leave it in gs.c instead

yes, probably a better idea. I'd still add the comment, though :)

shall I just fix this up when picking?
