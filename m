Return-Path: <kvm+bounces-65575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C2CCBCB0AC8
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 18:10:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 369DB301A6AB
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 17:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E8932A3C2;
	Tue,  9 Dec 2025 17:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="bFS8yp89"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45432329E58;
	Tue,  9 Dec 2025 17:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765300199; cv=none; b=LI4ajTBNJ5vrB0ppHmlzI/wotuxSIjVIkdpFA9MRtCJSFE0xaDOZeP7hgAmmSM24skhBEgCPji1c84KaU10sMEiEB8ahCcUgh2igertdWXDeaLyoIOoTZSfERHko8feqsRWJP0aBWRT/plLS9IWy8t7k7k9dv+UGeZgWC0fJQ3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765300199; c=relaxed/simple;
	bh=z8OjKOT4RNutfIgHez6i72DUHG46s9rYieh2p9avL2Q=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=GJeso87UGIlBlQLgyjnVuFzhNnQtEo5di005dipaIQesAyYtPRk82NhVqAP65kcaudz7mRrchIx8KBDy2V6b0OYrKjrX4UE9LwMmYFlm/qqMS3TWd3dxJYVafKKbPZnEg+jDObmGTm6IjVPrl49rrot9zkhI2hJFtjp4FcEobks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=bFS8yp89; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple (c-24-130-165-117.hsd1.ca.comcast.net [24.130.165.117])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5B9H97em3244256
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 9 Dec 2025 09:09:08 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5B9H97em3244256
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765300149;
	bh=fb5LcTM9tMm+70Si98qD4pqj+9EqFeGafJD049OCQjY=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=bFS8yp89+If2VFuzNyHK3UJqj5zxGu3l6WTEWppg77lkrGos6njwV89PJGAs9eN+H
	 M1+Ir0Ir5HlnOGJ2iP/ZVkn2s9TOrX5t5uM1LrnR8Xa4Cat+NamgfFRabbGoaesEZc
	 v99T5zDBT3eXSHe6zuzV4jg3PFc4wjGZq6UP75daWfTkZmcLBGNNE9thrH12MY8lq3
	 6kPsNFRC1eDf57ovosUJkMK9bPEvv6JlTnLFeGQ2ziC2g5MrPpt9ItuCjFdgG64Zy6
	 TEZmToYGJE8ZuscF0c96kz+rAkpd0WNhELi2gWXCEufUExRO3Pl7wsCNhfDJR6lEHh
	 AGTZGRmEiYcKg==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH v9 00/22] Enable FRED with KVM VMX
From: Xin Li <xin@zytor.com>
In-Reply-To: <aTdWbayU8BbR6eFu@google.com>
Date: Tue, 9 Dec 2025 09:08:57 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2FFF7711-DFA8-42DF-8E73-CAB6C8A6B1DD@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <aTdWbayU8BbR6eFu@google.com>
To: Sean Christopherson <seanjc@google.com>
X-Mailer: Apple Mail (2.3864.200.81.1.6)


> On Dec 8, 2025, at 2:51=E2=80=AFPM, Sean Christopherson =
<seanjc@google.com> wrote:
>=20
>> Xin Li (Intel) (4):
>=20
> I'm guessing the two different "names" isn't intended?

Not at all :=E2=80=99(

I've switched from using my Intel email to xin@zytor.com due to =
recipient
threshold limits.  Earlier versions of the patch series were sent to =
LKML
with the Intel address, while all new patches use xin@zytor.com.


