Return-Path: <kvm+bounces-23085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DA49B9462AD
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 19:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E75FB25154
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 17:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0CCA15C146;
	Fri,  2 Aug 2024 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OidNy4Iw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62811AE05E;
	Fri,  2 Aug 2024 17:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722620410; cv=none; b=H8GOcPz/rDPECSnSwMZdbf82tOsQYy/Wpk8R+tIoZTySXuqsPYfQYoeBkYHNhAbSKmo7eU0zy8qmk9A9G5N0/7JGPw2EPnAtAwymrXQZw4upnUCoQnsnd0xCvZublaWQ3XcqRp513xgW095YE11FchMf64q34Vej6MYeHnMAclM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722620410; c=relaxed/simple;
	bh=O+54GVQqjxUOx1zNFRkQaWEOJAdw70eBfVlXfVyrHPc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=KpoExCn+d+hbbzDA6SsTyD3JHNWbH0HdAYlL8tJUFNySe1LqVaxZDX+GX5yHZqf1+MkDP7D20rtfssemPBggTEkoKOmerNKWGVb7hIsppWJQhZWOdoM5w/GI5kkSrhpI1o+KW0DajfwOcFVl1NQ3m0+GziMQn6uywm0f1nq0DAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OidNy4Iw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5EAA9C4AF15;
	Fri,  2 Aug 2024 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722620409;
	bh=O+54GVQqjxUOx1zNFRkQaWEOJAdw70eBfVlXfVyrHPc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OidNy4IwOM6FzS+2C/BAtt7Bx8xpkXdBdXz6/CqTA4Ga32OEkyP2iW1mYlsx2sdPM
	 6qdDk1NbS/V22vDAhNaJSjETL4hsEB57gLB7/NaYGZe1hZ4rS1ebqlTcFtaTmJ5T8I
	 RTs6gbaZDcKo2jkr40ECn8VfRJX7FyaoUTcKPKBfjC6YD2G56ZDB5JOdE4/Ymn8C9I
	 +exLByPN7DcP1G5e40mx7N/ZAL+sHw9fJ2jnY62CzMOYr7/WkM0/KgIt9Mg5s8yyHz
	 41BbNFyxHV7fKA7Hpt7vRsFrNZ4LInUeOq6znwmFfjMiUv2YFM5FcMi7XHlCVUTtMb
	 P478Q4uRIMjaw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 51C6CD0C60A;
	Fri,  2 Aug 2024 17:40:09 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.11-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240802165116.9197-1-pbonzini@redhat.com>
References: <20240802165116.9197-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240802165116.9197-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 1773014a975919195be71646fc2c2cad1570fce4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 725d410facf9f232832bf6ea14a0c8814d890e06
Message-Id: <172262040932.22533.16401613941115228026.pr-tracker-bot@kernel.org>
Date: Fri, 02 Aug 2024 17:40:09 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri,  2 Aug 2024 12:51:16 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/725d410facf9f232832bf6ea14a0c8814d890e06

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

