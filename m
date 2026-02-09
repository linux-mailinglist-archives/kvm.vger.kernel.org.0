Return-Path: <kvm+bounces-70606-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UG1PEVYBimluFQAAu9opvQ
	(envelope-from <kvm+bounces-70606-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:46:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A70D1121BD
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:46:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DCE7B3006935
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 15:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA1A07082F;
	Mon,  9 Feb 2026 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sCKihAcm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB9F295DAC;
	Mon,  9 Feb 2026 15:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770651976; cv=none; b=Ay0XdvadxQWDRwuswadbdmFppuAUmUv84p+fErmqPJayHMhFW9vFu52fI0qB6cj9z5upQq98RHWviOkYHN0uj0c+eLkTiMmu9+5M11hrs6SB7vXWqty5WHDT68rNkcIRdQVcLyl6PBJaFyNXFyWXiPZwE2JkkGRqdQ95b1laevg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770651976; c=relaxed/simple;
	bh=jhfEoVZJEdyR5TaG8alhpg8oxqQVrZ1XGL/ucVPafEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tKIb6MiDNJe9O4PxKL1YX+bqQH2gRog8Q/8ZgR39UAGD/XDYSHB3FdlWcRURGeigCx3fZTkSD68XNPXPk0DJ520UpZT4pJGEu++5eY5Qja5PcfyP2LU+1jls/go8YaMH/++XQHVLEpiLQIodV4SyOWw3ua6YLaHwNrEO6uR2dVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sCKihAcm; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619B3W4R3201530;
	Mon, 9 Feb 2026 15:46:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=BbWKjTdp/3jJ0UACORzgCgVbzGPQji
	RHDe/OVLdyqaY=; b=sCKihAcmNiRuzX1WCtL6V1eRbdiV99CZM5VaAzgGrd6J2Y
	HdQWGpQ+8CA2u24fchJBn7o4cb5FLhhxlfC5ZiGYjE4x4T2UQfGoSNTwKFCLVgT7
	e2XXYZspdh9KAcEpe5KvYyBLWTbodVPUeum/u7M/fdUIIPbjxhypQeOM3k8WLITB
	keCstVJXLlr3Bzk4kJctJiFSLtZtX9GjeBrnVYhBfW8Ya6nkXqU7UTwsb0Nkt2nT
	0RpAN/sH5IsFrlukSpMgjP716so2F/GT9C43WoP6cpZY9DiVIksgEa/RQeHGptxU
	EqfDi8dJowY+PLCy6fhlsAz/d6CEhvNlOwfPVHSg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696vyw2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 15:46:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 619D06Ns008397;
	Mon, 9 Feb 2026 15:46:03 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6g3y5umh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 15:46:03 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 619FjvUF24379772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Feb 2026 15:45:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 197302004D;
	Mon,  9 Feb 2026 15:45:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7398720043;
	Mon,  9 Feb 2026 15:45:56 +0000 (GMT)
Received: from osiris (unknown [9.111.4.215])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  9 Feb 2026 15:45:56 +0000 (GMT)
Date: Mon, 9 Feb 2026 16:45:55 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Replace backup for s390 vfio-pci
Message-ID: <20260209154555.11973A16-hca@linux.ibm.com>
References: <20260202144557.1771203-1-farman@linux.ibm.com>
 <20260206151329.0d92d78e@shazbot.org>
 <8976d802-2edb-4239-ae74-2a5bca12be14@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8976d802-2edb-4239-ae74-2a5bca12be14@redhat.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=YeCwJgRf c=1 sm=1 tr=0 ts=698a013c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=r1p2_3pzAAAA:8 a=Jn7-a1IDzC4EnWudV9gA:9
 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=CjuIK1q_8ugA:10 a=r_pkcD-q9-ctt7trBg_g:22
X-Proofpoint-GUID: 042Lf00JHrZLma770Jz05E_2gZk4w6aY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDEyOCBTYWx0ZWRfX8g4BMyZkyoig
 qtaCgL6ORrYl+NH/wqJqsRqRQI0x4UGsbAd4PfeVL4YrNXBzofHQhk+QwyM5/MdNXmDK1llK2sv
 pWy9+mhUvfTauE1Er2Kn0Fx7VHxVS7NWTmdr+RPhECxOONiq3NLhBHFcKanaJu41A1Q1JFJvOgc
 VgNF5ZqgHBCsh88koKB2WXXYO7L3u0548MOjX+RVo8zDXaZGRD5AtNXo1uswOjo2X8p4L9LGbR3
 y958hoUkRjNnlS/1KFpAUKFq/mv7Va4mcrRWF4Mg/5Ah2rFr3x0BcpyoC18/uskMLd5na7zbB8B
 2lCMBgYaOmOH8LFlARtX4ovWXpuFZuXcLz3S2NX+EkGMJ4llt7PPAn8jUxteS6X+TBSzAmIWop7
 Nsaar8lY+TBx+gmzVyt4ANZlbGFKjezKcBFvuSxhUE73KNOrpBF20WoOWBLwTI1REicEqgCXEE/
 UizxkiHQyHNsaQqTVWw==
X-Proofpoint-ORIG-GUID: 042Lf00JHrZLma770Jz05E_2gZk4w6aY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1011 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602090128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70606-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linux.ibm.com:mid,shazbot.org:email];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hca@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 6A70D1121BD
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 08:44:27AM +0100, Thomas Huth wrote:
> On 06/02/2026 23.13, Alex Williamson wrote:
> > On Mon,  2 Feb 2026 15:45:57 +0100
> > Eric Farman <farman@linux.ibm.com> wrote:
> > 
> > > Farhan has been doing a masterful job coming on in the
> > > s390 PCI space, and my own attention has been lacking.
> > > Let's make MAINTAINERS reflect reality.
> > > 
> > > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > > ---
> > >   MAINTAINERS | 3 ++-
> > >   1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 0efa8cc6775b..0d7e76313492 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -23094,7 +23094,8 @@ F:	include/uapi/linux/vfio_ccw.h
> > >   S390 VFIO-PCI DRIVER
> > >   M:	Matthew Rosato <mjrosato@linux.ibm.com>
> > > -M:	Eric Farman <farman@linux.ibm.com>
> > > +M:	Farhan Ali <alifm@linux.ibm.com>
> > > +R:	Eric Farman <farman@linux.ibm.com>
> > >   L:	linux-s390@vger.kernel.org
> > >   L:	kvm@vger.kernel.org
> > >   S:	Supported
> > 
> > Acked-by: Alex Williamson <alex@shazbot.org>
> > 
> > Given the cc list, I'm guessing this is intended to go via s390,
> > otherwise please let me know if I should take it.  Thanks,
> 
> Yes, I'll queue it for my next PR.

Are you sure you didn't confuse this with the nearly identical looking
qemu patch? Just asking... :)

