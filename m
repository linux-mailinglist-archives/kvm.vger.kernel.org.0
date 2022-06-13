Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A431C5499F3
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 19:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbiFMR1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 13:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240509AbiFMR0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 13:26:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E39326E7;
        Mon, 13 Jun 2022 05:40:45 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25DBu3aq023302;
        Mon, 13 Jun 2022 12:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=zblCug8/eDubWXpzDjmru/DjNcNtDEU1gUX3Ngmzcr0=;
 b=qQHERf6xTa0O/wUaXFdT17gCGq3IIT+nvnT8OeEG7XVODS8ifXnVZTCYit/HrHJkiUJW
 fGeI61jfqDZAonWPGBMPjDotWUsmHh5qaNkbXZgO1M49JobslJnCW/U15XkfKs9Spk3V
 yu48ShJRutGgx5OZ2sH63Tm193C6bMmYSAQAHCkmOjZelSfQBSagIDkTR6ysl6yw9an4
 UL4IsWGek+Me82IOnGY4XmjqChNIvP4egjBgMJq/6Y/l0AJ/gu/0WZdwPuDjqo3FR4LT
 X8FJP3m3Fao/YDX34/XoVj7EAtMY3S7vbw0MiUIy3H43DYHqKDvtqlPMhgOU1ZAmEkkx Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gn4yhfm4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 12:40:44 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25DCDV2Z001532;
        Mon, 13 Jun 2022 12:40:44 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gn4yhfm41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 12:40:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25DCKN1k025199;
        Mon, 13 Jun 2022 12:40:41 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3gmjp9as7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 12:40:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25DCefkJ25231660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jun 2022 12:40:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CE07A4053;
        Mon, 13 Jun 2022 12:40:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5DD7A404D;
        Mon, 13 Jun 2022 12:40:37 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.53.163])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 Jun 2022 12:40:37 +0000 (GMT)
Message-ID: <edada13d972cff5626283fb3c45277d2ddc8ec24.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Rework TEID decoding and
 usage
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Mon, 13 Jun 2022 14:40:37 +0200
In-Reply-To: <1c233f7b-2a21-bbf2-92ef-fb1091423cbd@linux.ibm.com>
References: <20220608133303.1532166-1-scgl@linux.ibm.com>
         <20220608133303.1532166-4-scgl@linux.ibm.com>
         <1b4f731f-866c-5357-b0e0-b8bc375976cd@linux.ibm.com>
         <fadd5a33-89ef-b2b3-5890-340b93013a34@linux.ibm.com>
         <1c233f7b-2a21-bbf2-92ef-fb1091423cbd@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W78qyxsKk-W6Fekuym9lr7OZ42Zz-r3U
X-Proofpoint-GUID: 72EG-GMdEqcephuxlQ9qgifnCqh4X0E_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_05,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206130056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-10 at 14:10 +0200, Janosch Frank wrote:
> On 6/10/22 12:37, Janis Schoetterl-Glausch wrote:
> > On 6/10/22 11:31, Janosch Frank wrote:
> > > On 6/8/22 15:33, Janis Schoetterl-Glausch wrote:
> > > > The translation-exception identification (TEID) contains information to
> > > > identify the cause of certain program exceptions, including translation
> > > > exceptions occurring during dynamic address translation, as well as
> > > > protection exceptions.
> > > > The meaning of fields in the TEID is complex, depending on the exception
> > > > occurring and various potentially installed facilities.
> > > > 
> > > > Rework the type describing the TEID, in order to ease decoding.
> > > > Change the existing code interpreting the TEID and extend it to take the
> > > > installed suppression-on-protection facility into account.
> > > > 
> > > > Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> > > > ---
> > > >    lib/s390x/asm/interrupt.h | 61 +++++++++++++++++++++++++++---------
> > > >    lib/s390x/fault.h         | 30 +++++-------------
> > > >    lib/s390x/fault.c         | 65 ++++++++++++++++++++++++++-------------
> > > >    lib/s390x/interrupt.c     |  2 +-
> > > >    s390x/edat.c              | 26 ++++++++++------
> > > >    5 files changed, 115 insertions(+), 69 deletions(-)
> > > 

[...]

> > > > +static void print_decode_pgm_prot(union teid teid, bool dat)
> > > > +{
> > > > +    switch (get_supp_on_prot_facility()) {
> > > > +    case SOP_NONE:
> > > > +        printf("Type: ?\n");
> > > > +        break;
> > > > +    case SOP_BASIC:
> > > > +        if (teid.sop_teid_predictable && dat && teid.sop_acc_list)
> > > > +            printf("Type: ACC\n");
> > > > +        else
> > > > +            printf("Type: ?\n");
> > > > +        break;
> > > 
> > > I'm wondering if we should cut off the two possibilities above to make it a bit more sane. The SOP facility is about my age now and ESOP1 has been introduced with z10 if I'm not mistaken so it's not young either.
> > 
> > So
> > 
> > case SOP_NONE:
> > case SOP_BASIC:
> > 	assert(false);
> > 
> > ?
> 
> I'd check (e)sop on initialization and abort early so we never need to 
> worry about it in other files.

We could just ignore those cases since we don't depend on them for the
tests to function. Breaking all tests seems disproportional to me.
> 
> > 	
> > > 
> > > Do we have tests that require SOP/no-SOP?
> > 
> > No, just going for correctness.
> > 
> 

