Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BF16C331E
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 14:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjCUNoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 09:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjCUNoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 09:44:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEE3C655
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 06:43:59 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32LCv9qC005627;
        Tue, 21 Mar 2023 13:43:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : content-transfer-encoding : mime-version; s=pp1;
 bh=1GMaDkpv/qcVBFp37IfT3wOFmO6whM+7W8zDnUBbUDA=;
 b=Nchhq6S8xdum808Zi4EUMraR1J8zRKLgxqXAqHfd6G6mabqc1P8PIf52uOUbZZizw7b2
 8SMD6uD/fvQlw7MP44aXHWef0r59HXYpkrA3vViV+9iNbiOoNFCexmP+aBGgcduMx4wW
 N1ln1iPkeW7ylHml9FwVcj9D5M/24HtFdFAG/R4bYKpGBvYl/n1LgJ/q7VE2eVsh2Ro8
 StZRXPahl5PlTl2Y9YMxw+sR4TXxB9Y5Dmd8qXLsMm0eZP95PaKA6aU2iQHTPV7WVdA8
 YyKHNBYrpNVenwMRH2zlZmZJy4FI6lM4U1hTRkeHng23VPmN6+EwT6E4bSP6ilM6skU9 wQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pf7qns9rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Mar 2023 13:43:52 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32LBmxwD020656;
        Tue, 21 Mar 2023 13:43:51 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3pd4x7fdyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Mar 2023 13:43:51 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32LDhoS88716892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 13:43:50 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 703A458061;
        Tue, 21 Mar 2023 13:43:50 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C284E58058;
        Tue, 21 Mar 2023 13:43:49 +0000 (GMT)
Received: from nat-wireless-guest-reg-153-54.bu.edu (unknown [9.163.23.201])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 21 Mar 2023 13:43:49 +0000 (GMT)
Message-ID: <c2e8af835723c453adaba4b66db533a158076bbf.camel@linux.ibm.com>
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     =?ISO-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
Cc:     amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Date:   Tue, 21 Mar 2023 09:43:48 -0400
In-Reply-To: <ZBmmjlNdBwVju6ib@suse.de>
References: <ZBl4592947wC7WKI@suse.de>
         <66eee693371c11bbd2173ad5d91afc740aa17b46.camel@linux.ibm.com>
         <ZBmmjlNdBwVju6ib@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0N1Ti4wqD48g2xLu1DEn-gB15xjh1zAO
X-Proofpoint-ORIG-GUID: 0N1Ti4wqD48g2xLu1DEn-gB15xjh1zAO
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_08,2023-03-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 phishscore=0 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303210103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-03-21 at 13:43 +0100, Jörg Rödel wrote:
> Hi James,
> 
> On Tue, Mar 21, 2023 at 07:09:40AM -0400, James Bottomley wrote:
> > Since this a fork of the AMD svsm code
> > (https://github.com/AMDESE/linux-svsm/), is it intended to be a
> > permanent fork, or are you going to be submitting your additions
> > back upstream like we're trying to do for our initial vTPM
> > prototype? From the community point of view, having two different
> > SVSM code bases and having to choose which one to develop against
> > is going to be very confusing ...
> 
> The COCONUT-SVSM was and is a separate project and not a fork of AMDs
> linux-svsm. Some code was ported from our code-base to linux-svsm in
> the past, namely the SpinLock implementation and the memory
> allocators.

Well at the time you submitted the pull request, Coconut wasn't public,
so I don't think it looked like a port from a separate code base when
it happened.  But anyway, I'm not so interested in who is based on
whom, I'm more interested in how we avoid dividing our efforts on
confidential computing going forwards.

> What the project also shares with linux-svsm is the support code in
> the Linux kernel (host and guest) and the EDK2 changes needed to
> launch an SVSM.
> 
> But besides that the two code-bases are different, using a different
> build approach and different launch protocol. The goals we have with
> our SVSM are hard to achieve with the linux-svsm code-base, so a
> merge does not make sense at this point.

Could you describe these incompatible goals and explain why you think
they are incompatible (as in why you and AMD don't think you can agree
on it)?  That would help the rest of us understand where the two SVSM
implementations fit in our ongoing plans.

Regards,

James

