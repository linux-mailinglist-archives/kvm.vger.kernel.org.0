Return-Path: <kvm+bounces-68637-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4JNiGl7Wb2mVRQAAu9opvQ
	(envelope-from <kvm+bounces-68637-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 20:24:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 035814A452
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 20:24:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1627950E734
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 18:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 211FF44BC9A;
	Tue, 20 Jan 2026 18:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Qmv529zj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A65363C75;
	Tue, 20 Jan 2026 18:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768932342; cv=none; b=QduNVlJBkcAz0q/5oI91TA7GoAolSHaTuHr7mlaId9XbP2VHWArgFSNI2+6yFU4vv0xvFDL0+1IC1vcn8+p9uLyfmKZtTpqu4jW9c+PvsjX0lWj83yR72xapqNk4T9X1PZsmtua4MRFZm6kAhkyRrdKnnhdY2TDU4WXVCPt6vCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768932342; c=relaxed/simple;
	bh=t8pxAjGHqxhIUw42LY58cBJinFtjuQYdzgoYGlBU5II=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=XBigGRgWl0s21PYMfc1Zy7q6uYAvosiFCTX1rVTzdJlH9ENny0Ul1NjOLA7K0TQhncPNj0f3u0ikjA9QdWNd+yeFYXV1W0qzLtwtx3NbMEqSy8jbhcyH3Q2gpIpn5mbH1bJT+dlc9BWIKy8Z6B6ynh5wC7p1NhbCNYb0PqGBlUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Qmv529zj; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60KI575l3818110
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 20 Jan 2026 10:05:08 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60KI575l3818110
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1768932309;
	bh=qvhm6Bwt6RSQM25IbmsOFca4YmHzKStlPY6tm/YMdM4=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=Qmv529zj88UeS1sU2FeIGZLgF+wnjLYmOh5aLktQS3W6WJE+Kk+KEjofuvbKkPbct
	 ZBR7rbJhN0Ybnbw/Op2wu+ESRG8EE5xdqg4blFCecesyQ80y4JYD1XjEQ0ysIf9HiT
	 Vb+3Yu1fifkTgzhYYEHRA7dOd7p35j7PhTXgnox9u3YGZYMb3HacGDYq9ZnlzzJbts
	 tPoHexDiLxsZ0iZ5KaHUvXLpihYrRo0fbfpaZGk8QjH4vRGX/xIvP01pqzoTNlXDs8
	 iqo0QCiwB2DHY0XCBP67q0cy0yDn17AdFUx5lid5lfiz/wveIeB26/7Hzc+LDThJZL
	 hgIWlrAfUecOw==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v9 17/22] KVM: x86: Advertise support for FRED
From: Xin Li <xin@zytor.com>
In-Reply-To: <aW-eWcj5GBZfGerc@google.com>
Date: Tue, 20 Jan 2026 10:04:57 -0800
Cc: Binbin Wu <binbin.wu@linux.intel.com>, Chao Gao <chao.gao@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <CB372B69-7B1C-44B6-A4C3-179C7387B8FC@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-18-xin@zytor.com> <aRQ3ngRvif/0QRTC@intel.com>
 <71F2B269-4D29-4B23-9111-E43CDD09CF13@zytor.com> <aW83vbC2KB6CZDvl@intel.com>
 <C3F658E2-BB0D-4461-8412-F4BC5BCB2298@zytor.com>
 <04d96812-f74a-4f43-9ea4-c4f2723251c5@linux.intel.com>
 <aW-eWcj5GBZfGerc@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2025122301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68637-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[zytor.com,none];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[zytor.com:+];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,zytor.com:mid,zytor.com:dkim]
X-Rspamd-Queue-Id: 035814A452
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


> On Jan 20, 2026, at 7:25=E2=80=AFAM, Sean Christopherson =
<seanjc@google.com> wrote:
>=20
>>>=20
>>> What I have missed?
>=20
> The userspace VMM, e.g. QEMU, is completely irrelevant.  KVM must not =
advertise
> support for features it doesn't actually implement, and more =
importantly must not
> internally treat such features as supported.

Right, FRED virtualization is not supported on AMD and obviously SVM =
will
need to add FRED virtualization in their own fashion later.

>=20
>> If a newer QEMU (with AMD's FRED support patch) + an older KVM =
(without AMD's
>> FRED support, but KVM advertises it), it may cause issues.
>=20
> Yep.
>=20
>> I guess it's no safety issue for host though,
>=20
> Maybe.  Without fully analyzing the SVM implementation for FRED and =
its interaction
> with KVM, I don't think we can confidently say that incorrectly =
treating FRED as
> supported is benign for the host.  It's a moot point, I just want to =
emphasize
> how it important it is that KVM doesn't over-report features.

I will remove it on AMD.

