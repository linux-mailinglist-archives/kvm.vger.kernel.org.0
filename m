Return-Path: <kvm+bounces-68627-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mPunBbPLb2mgMQAAu9opvQ
	(envelope-from <kvm+bounces-68627-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 19:38:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BD2949968
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 19:38:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 288E55EB795
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 15:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECF6044CACE;
	Tue, 20 Jan 2026 15:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UI/lACyh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D1221323C;
	Tue, 20 Jan 2026 15:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768922604; cv=none; b=HFYZxwWF2zEjcUVw4W7EJfqF6FqX3ggocK8R19qHHT+RiBZf3RtQ2Z1fIVxhyH0XOpHJnMCHZbMV2YeA9YnLIh5bWC7pxK19dWn52sIt61SBGcOKupHBIm3DPRSGcW/RzcHuOr2+ARNvjf3/tzmsEnCy0A32InE4uddApVwLDBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768922604; c=relaxed/simple;
	bh=737+/LsyWsdLMKN+/+ZbCQWMh98zh88rmud7iJXFBpQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KODQOjC61HBbVrx/SqPWmGFkBvUmPJFDc8yixNmx72Yv/gJKv2EOk5zHd5Q17onKaRjMNwWSeqXMTiiTy5HiL57ZhWv5DQJ/Ap531DNKMzfC4dpY/9nE0NKQCQ0/zFpFXGl9DZR75jxCb70pQnKiF9z+1kRgG18khzuvDWLgS/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UI/lACyh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60KEkhsc020571;
	Tue, 20 Jan 2026 15:23:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=737+/L
	syWsdLMKN+/+ZbCQWMh98zh88rmud7iJXFBpQ=; b=UI/lACyhrDW+uI7ZPM069E
	CwjTQK9YUO3RiR7AhH9ImxekpY5mdG7oNC1VperlwSO/ku10LotXwUG0lt6ERs/E
	qXdjGECYOLqqk1t8YuX3Uv2aWAsW8hxfC5+UtWbmWIEKv1w88MPCF0wIHJRYNiii
	09ocfZMgqA8qFDPwOyxIU5/rq8Nx9gYVsHEmRGVQXewxYDPwGi+owPLRhVNdMT4/
	i9OB1YrXyG5K8nMfs4MjaT5J2G8TN8V6hUN3KxKte2mF6ETqAR+Y7gllEaCCy1Ls
	+YcjkCSBSoeBSqM3r72OCHWuuXmRv8XJ/TidgkLBok8rQayhABLN7aHCl6f7ZWZw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4br0ufdqh8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jan 2026 15:23:17 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60KF0Qnv006427;
	Tue, 20 Jan 2026 15:23:16 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4brqf1dcr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Jan 2026 15:23:16 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60KFNEAe21889746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 15:23:15 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D51A55805B;
	Tue, 20 Jan 2026 15:23:14 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9C7A58059;
	Tue, 20 Jan 2026 15:23:13 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.131.235])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 Jan 2026 15:23:13 +0000 (GMT)
Message-ID: <b4038398b51f9f1fa58aa76c78cf5ce0e50e5113.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE when unable to get vsie_page
From: Eric Farman <farman@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda
	 <imbrenda@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand
	 <david@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date: Tue, 20 Jan 2026 10:23:13 -0500
In-Reply-To: <c3ef38be-602e-40ce-a451-92088c67d88f@linux.ibm.com>
References: <20251217030107.1729776-1-farman@linux.ibm.com>
	 <8334988f-2caa-4361-b0b9-50b9f41f6d8a@linux.ibm.com>
	 <f34d767b2a56fb26526566e43fa355235ee53932.camel@linux.ibm.com>
	 <20260114105033.23d3c699@p-imbrenda>
	 <23154a0c6b4b9e625daa2b1bbaadc349bf3a99ed.camel@linux.ibm.com>
	 <3d997b2645c80396c0f7c69f95fd8ec0d4784b20.camel@linux.ibm.com>
	 <c3ef38be-602e-40ce-a451-92088c67d88f@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: naHqG2ZgSj6wPbHtX4qvQGlWOh4whxzz
X-Proofpoint-ORIG-GUID: naHqG2ZgSj6wPbHtX4qvQGlWOh4whxzz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDEyNyBTYWx0ZWRfX58ySOYl887Mm
 wMQn4xbn28JmDtG8l0mk3dVWh909AmvPSqZ6DD5+UJadsMcv216htMPoxo8ZPojbrSTgFv1WEbU
 GfPG4109r/7wkfMohGIo5ThgBrUO1D7dn+LVV6ypffeB0GVUI2lJnwDm+bprx92t2wbvUwDv53g
 hAlXOxPOP5JgskfMAlQBO/eBUaafvQOoLxvYbtrYJj9A9Ttq5Iap4TUyBWCvdRe8Rn2TBFSogE/
 uKwWgaVj9DnVeLJM5u6y8S4JcrsvtSmE0lGmL1Qz4MbYl1JCp6ji/w8thqau0S+kC8mPE94H4NY
 26TP/uU/+mMAJ8CpSYWeFxE/yU9JURvSugG2GlAhohqs++DQASJh5ZYR145wtqiI9L42j3Ti8UN
 3VEx4pA1A9sdx9hRViBWKInuyv1Znxk09POX//se7ykCcovpbVigUAXgpLfK8AMg2/7tYg4mgd/
 3PzcUooii3Wwza1Ks9w==
X-Authority-Analysis: v=2.4 cv=bopBxUai c=1 sm=1 tr=0 ts=696f9de5 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=cP2koYoijfjhQiI88GMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_04,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601200127
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[ibm.com,none];
	DKIM_TRACE(0.00)[ibm.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68627-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[farman@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 8BD2949968
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, 2026-01-19 at 15:49 +0100, Janosch Frank wrote:
> On 1/16/26 16:45, Eric Farman wrote:
> > On Thu, 2026-01-15 at 16:17 -0500, Eric Farman wrote:
> > > On Wed, 2026-01-14 at 10:50 +0100, Claudio Imbrenda wrote:
> > > > On Mon, 05 Jan 2026 10:46:53 -0500
> > > > Eric Farman <farman@linux.ibm.com> wrote:
> > > >=20
> > > > > On Mon, 2026-01-05 at 13:41 +0100, Janosch Frank wrote:
> > > > > > On 12/17/25 04:01, Eric Farman wrote:
> > > > > > > SIE may exit because of pending host work, such as handling a=
n interrupt,
> > > > > > > in which case VSIE rewinds the guest PSW such that it is tran=
sparently
> > > > > > > resumed (see Fixes tag). There is still one scenario where th=
ose conditions
> > > >=20
> > > > can you add a few words to (very briefly) explain what the scenario=
 is?
> > >=20
> > > Maybe if this paragraph were rewritten this way, instead?
> > >=20
> > > --8<--
> > > SIE may exit because of pending host work, such as handling an interr=
upt,
> > > in which case VSIE rewinds the guest PSW such that it is transparentl=
y
> > > resumed (see Fixes tag). Unlike those other places that return rc=3D0=
, this
> > > return leaves the guest PSW in place, requiring the guest to handle a=
n
> > > intercept that was meant to be serviced by the host. This showed up w=
hen
> > > testing heavy I/O workloads, when multiple vcpus attempted to dispatc=
h the
> > > same SIE block and incurred failures inserting them into the radix tr=
ee.
> > > -->8--
> >=20
> > Spoke to Claudio offline, and he suggested the following edit to the ab=
ove:
> >=20
> > --8<--
> > SIE may exit because of pending host work, such as handling an interrup=
t,
> > in which case VSIE rewinds the guest PSW such that it is transparently
> > resumed (see Fixes tag). Unlike those other places that return rc=3D0, =
this
> > return leaves the guest PSW in place, requiring the guest to handle a
> > spurious intercept. This showed up when testing heavy I/O workloads,
> > when multiple vcpus attempted to dispatch the same SIE block and incurr=
ed
> > failures inserting them into the radix tree.
> > -->8--
> >=20
> > >=20
> > > @Janosch, if that ends up being okay, can you update the patch or do =
you want me to send a v2?
>=20
> I can fix that up.

Great, thank you!

