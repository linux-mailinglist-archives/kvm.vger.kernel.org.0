Return-Path: <kvm+bounces-31957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2B39CF41F
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 19:40:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EE1B281BB5
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 18:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB83A1DDC03;
	Fri, 15 Nov 2024 18:40:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF6418FC89;
	Fri, 15 Nov 2024 18:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731696029; cv=none; b=lUPiSlCMRSHGlMcKH3m0fN6aLDjJGbAhyy+9yMajFb/8F3E9hgphgvt+bH8g6eIy4JYBwHH8FeZWNuhw+5YzfeiYijm1QlgppgmTApDWpX0rV6YhuNQ3w2SAU3KE6hYASpRBn0CI37MWy0KrScQOBq/RNAF7fMtATqiFGi5WNVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731696029; c=relaxed/simple;
	bh=HmOktjV0HHUKaU1clys5bIHx0uhlwjdvMNzTLRHbODE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EyUs26Gc4NkMfMt6l46KZ/tZWqosV4tHX0OTU1y7vqqOeNQa2yf14+O4TceNHQ8ZRXfu3tzOl9j/upKUyOqjNL0Ina545U/hQ/uz2zg6cV9viSHYGwPuCd0TrpwmU6zT+b3gj71l8nznf1pJrE0iycWdSGe5yTDP1aUVXpQRpBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3D7C4CECF;
	Fri, 15 Nov 2024 18:40:28 +0000 (UTC)
Date: Fri, 15 Nov 2024 10:40:27 -0800
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	jthoughton@google.com
Subject: Re: [PATCH v2 07/12] objtool: Convert ANNOTATE_INTRA_FUNCTION_CALLS
 to ANNOTATE
Message-ID: <20241115184027.64qogefila6oy7qr@jpoimboe>
References: <20241111115935.796797988@infradead.org>
 <20241111125218.788965667@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241111125218.788965667@infradead.org>

On Mon, Nov 11, 2024 at 12:59:42PM +0100, Peter Zijlstra wrote:
> +++ b/include/linux/objtool_types.h
> @@ -63,5 +63,6 @@ struct unwind_hint {
>  #define ANNOTYPE_INSTR_END		4
>  #define ANNOTYPE_UNRET_BEGIN		5
>  #define ANNOTYPE_IGNORE_ALTS		6
> +#define ANNOTYPE_INTRA_FUNCTION_CALLS	7

Should be a singular "CALL"?

-- 
Josh

