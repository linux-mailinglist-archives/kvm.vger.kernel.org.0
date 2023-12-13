Return-Path: <kvm+bounces-4321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF6481113E
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:43:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8219F1C20EFA
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 12:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E04528E38;
	Wed, 13 Dec 2023 12:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qq2nN8wP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F3911A;
	Wed, 13 Dec 2023 04:43:29 -0800 (PST)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDCNv0G026163;
	Wed, 13 Dec 2023 12:43:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=3P4mF1U1catJ/0RHY0io+Zd41V6xKcH6OFa5aBbmp0M=;
 b=qq2nN8wPOqC+Das7fNosYy9e9Yy9DYjPyUbbF9ofbgtV467jaXit2cB8UYksWho3odgy
 itgDroGTels1gd+0EfVkP2/edLq94/g3B0tqkxJftob1InvJ3h6rpI+iftMwlK8LnZ4P
 MvJMhwSS9yuzL0Gi2Fi/VhKcc3w0udplmuNJbtVwoj9Wt4p7Llbk+Los1bjOIVkNtw8B
 Eq9PV483pM9UZVJNesxZzjvlEooPIPpzw5Ho1RvdvpXdybHQCqS5oej/FFMVZNpejSje
 2KfyLxjUIjBhhK+XAEtNQgisK+PwPRp2/wTSIZP/jQfQYAYx7rbv6xNtcdGEPIWAvnSk mA== 
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uycjwgm4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:43:28 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDArZVA004139;
	Wed, 13 Dec 2023 12:43:28 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uw4skgcyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:43:28 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDChQ8F197142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 12:43:27 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D45065805A;
	Wed, 13 Dec 2023 12:43:26 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9048A58054;
	Wed, 13 Dec 2023 12:43:25 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.110.228])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Dec 2023 12:43:25 +0000 (GMT)
Message-ID: <81409a5fbe25ff2f3fcb3b6da2439ed5262ad5d3.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: fix cc for successful PQAP
From: Eric Farman <farman@linux.ibm.com>
To: Anthony Krowiak <akrowiak@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Halil Pasic
 <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date: Wed, 13 Dec 2023 07:43:25 -0500
In-Reply-To: <918b6276-f423-49c8-8719-4517e9d23bad@linux.ibm.com>
References: <20231201181657.1614645-1-farman@linux.ibm.com>
	 <fe3082f7-70fd-479f-b6a2-d753d271d6d5@linux.ibm.com>
	 <0fe89d1a4ef539bef4bdf2302faf23f6d5848bf2.camel@linux.ibm.com>
	 <918b6276-f423-49c8-8719-4517e9d23bad@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.50.2 (3.50.2-1.fc39) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ygi-5ikECu4ckdLuK-7uPFB27XWcKzAU
X-Proofpoint-ORIG-GUID: ygi-5ikECu4ckdLuK-7uPFB27XWcKzAU
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_05,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 phishscore=0
 mlxlogscore=769 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312130093

On Fri, 2023-12-08 at 09:21 -0500, Anthony Krowiak wrote:
>=20
> On 12/8/23 6:24 AM, Eric Farman wrote:
> > On Fri, 2023-12-08 at 11:31 +0100, Janosch Frank wrote:
> > > On 12/1/23 19:16, Eric Farman wrote:
> > > > The various errors that are possible when processing a PQAP
> > > > instruction (the absence of a driver hook, an error FROM that
> > > > hook), all correctly set the PSW condition code to 3. But if
> > > > that processing works successfully, CC0 needs to be set to
> > > > convey that everything was fine.
> > > >=20
> > > > Fix the check so that the guest can examine the condition code
> > > > to determine whether GPR1 has meaningful data.
> > > >=20
> > > Hey Eric, I have yet to see this produce a fail in my AP KVM unit
> > > tests.
> > > If you find some spare time I'd like to discuss how I can extend
> > > my
> > > test
> > > so that I can see the fail before it's fixed.
> > >=20
> > Hi Janosch, absolutely. I had poked around kvm-unit-tests before I
> > sent
> > this up to see if I could adapt something to show this scenario,
> > but
> > came up empty and didn't want to go too far down that rabbit hole
> > creating something from scratch. I'll ping you offline to find a
> > time
> > to talk.
>=20
>=20
> If this is recreateable, I'd like to know how. I don't see any code
> path=20
> that would cause this result.

Janosch and I spoke offline... He was using a proposed series of kvm-
unit-tests [1] as a base, but the condition code of the PSW was zero at
the time of the PQAP, meaning everything seemed fine. By dirtying the
CC before the PQAP, this problem pops up quite easily, and this patch
gets things back in line.

[1]
https://lore.kernel.org/kvm/20231117151939.971079-1-frankja@linux.ibm.com/

>=20
>=20
> >=20
> > Eric
> >=20
>=20


