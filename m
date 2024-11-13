Return-Path: <kvm+bounces-31774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B912C9C77E6
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 16:55:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A5991F2349E
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 15:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6F7148828;
	Wed, 13 Nov 2024 15:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="ryBxYC+6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="McfWnMBH"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6950815C14F;
	Wed, 13 Nov 2024 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731513302; cv=none; b=NkGMQK6eRV2HShtm/MjRqjvBYfb9XmoltNjwrlnLUnmdiG01mjMsoFXxc0w5I7zrZAN21PIhElbAT0k3ziVMkAVYRCPV84SLiwRuQEdIU1VThBY26Ny1THidECmsjgCyJmO1IgZA5eFO8A5nRuFk4jGoLU1BPdDp7ZETaQ6vFrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731513302; c=relaxed/simple;
	bh=b6raCtJWp3Lrtmt82BKBBCDTyBvC2ZcakCXrj2CG5fY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=LOx7VKoV/t87OSBKx7eAdMKy7if4eYNfpQN0LeafaZZjk4TAdSTmG2MGtJgagJI8I319lZ2d9f99N3pfUI1qMH9vM2vP9H1tXIMYgc1KexeKTiNHqE/Oz94rman/YPctqFg5faAXCDPHxD+9neZqap74mFnUTCX+qaW6/pBdqkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=ryBxYC+6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=McfWnMBH; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id D7907114019C;
	Wed, 13 Nov 2024 10:54:57 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-10.internal (MEProxy); Wed, 13 Nov 2024 10:54:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1731513297;
	 x=1731599697; bh=czwPBljBW6AVGfYo7dHlvTWz3D+Y4F6MZEMNWo3u4TI=; b=
	ryBxYC+6nLUrw6xhwDLaU9w4v58WDdofhK0Q1hydOpn/UU+jeMa0cm/a5pqde2AS
	8krGEzq10Q1nx6ARR5z/4UfqV4hAhpKci/vHZ5sbTC7+F5D4oGtz3fejw2D0U0i6
	qKcY+rrXrlDe/E2AniU+XGQyzOFxAInJm5NYJDyWjtsIo00iyAexHZZ2l2r+2AOH
	uzqTAZSgq8aZWK/NK+Aol1jn5f6iqhOUQyCWKvAbuNMtwC7cq4U6fKgJP84edIED
	afIfgoTDBdikFV/ewjF9fkSOHxslXmA7WWCiGRWkYPaXaN021ujxIRYCPJ/zhz09
	O6e2ht9TGcWPLhcbm/vrmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1731513297; x=
	1731599697; bh=czwPBljBW6AVGfYo7dHlvTWz3D+Y4F6MZEMNWo3u4TI=; b=M
	cfWnMBH/I553+pJNrNatFiHT5PLU2xs/0V/yQXEbizkzfeWcci3458py1hJfbNwG
	YCk4PSd2cHnaZNMUwrW7xsilVWyO/TYLLXnfoKJJ9dIRgSUrevUmszVB3Abpwoty
	i89qN/p6oE7mlYPHzDdJN6rGFGo8AO2TI4DM6HJ3XlOHLnM91SYzcWYpk9/IAzny
	3xS/Ui4xcxe1rdSbRlrjvCgpEVNx+2zf5ag6u1OBM22wl/FV4ngyQ7Vz+oXggcH1
	85yTBgz/+JUn0pqOwnlCx+6s4k8enKsPsP81AShqp0Bq1YMHtl4UsE02br+CGGiA
	dx0A10RwXCN12KTUwQmbw==
X-ME-Sender: <xms:0cs0Z96tl1lYLdQExseoqt9ZU66qY96Smb3Lozhm-8DDtoDH5YYGTA>
    <xme:0cs0Z66XaIA2WecykFuc2M5RgQXmu-zNLqnhfyQxOMCJy5WL3bj9WpT4CbSabvntC
    uIje4aBSs-jnxmuPGE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrvddtgdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredttden
    ucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdrug
    gvqeenucggtffrrghtthgvrhhnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffg
    vedugeduveelvdekhfdvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduhedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtg
    hpthhtohepmhhitghhrggvlhdrrhhothhhsegrmhgurdgtohhmpdhrtghpthhtohepshgv
    rghnjhgtsehgohhoghhlvgdrtghomhdprhgtphhtthhopehishgrkhhurdihrghmrghhrg
    htrgesihhnthgvlhdrtghomhdprhgtphhtthhopehlkhhpsehinhhtvghlrdgtohhmpdhr
    tghpthhtoheprghrnhgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdp
    rhgtphhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:0cs0Z0dBl1SSgKmWmej0sHzJAWYvJkfUVR6r1QhYP6yeYkVKEuz30g>
    <xmx:0cs0Z2IBZO32QBkgqA8A2YqPKDOeHg8Wg5boUwvcXLOIICRC7IHGZA>
    <xmx:0cs0ZxJnbmu_VxgSl4Vrlk4juVnZbjcH-nPeU_taq8jfEASaRARg_A>
    <xmx:0cs0Z_yqGhD1yEo0G1si8vc07SkmDhWARr3wYRCpcfo_tMdj2Jo2Jg>
    <xmx:0cs0ZzjDN-t1aHOYQWS4BHWbu63_XkQV6nPR13C5lJxCp6Q-AF7bOzzC>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 425D02220071; Wed, 13 Nov 2024 10:54:57 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 13 Nov 2024 16:54:36 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Sean Christopherson" <seanjc@google.com>,
 "Arnd Bergmann" <arnd@kernel.org>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "kernel test robot" <lkp@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 "Michael Roth" <michael.roth@amd.com>,
 "Isaku Yamahata" <isaku.yamahata@intel.com>,
 "Vitaly Kuznetsov" <vkuznets@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <e1c9a950-ffd9-4b84-b416-8d7b3054ed5a@app.fastmail.com>
In-Reply-To: <ZzS62W60NS_sM31K@google.com>
References: <20241112065415.3974321-1-arnd@kernel.org>
 <ZzS62W60NS_sM31K@google.com>
Subject: Re: [PATCH] x86: kvm: add back X86_LOCAL_APIC dependency
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Nov 13, 2024, at 15:42, Sean Christopherson wrote:
>
> The dependency can and should go on "config KVM", not on the vendor 
> modules.  The net effect on the build is the same, but preventing
> the user from  selecting KVM will provide a slightly better experience.

Makes sense, sending v2 now.

       Arnd

