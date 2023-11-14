Return-Path: <kvm+bounces-1648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 604F17EB03A
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 13:50:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8948B20B21
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 12:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8953FB2E;
	Tue, 14 Nov 2023 12:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DlDbcEIe"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C013E475
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 12:50:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D230618A
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 04:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699966243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+dtR7uxZYKr8ZF2Mvilnq0MwzlXpAsQU4Jpz/lAT/98=;
	b=DlDbcEIeXX/clHcRl+5PvqRIj1d99M55+LA8IA5aD2uc1TavOW2AIbC3NhNNv5/u5rdJyV
	TyZQOFB0U0kBDvEOclTDfC1svJzkY3Ocjw2nJQxvcq/dHSPVioPG75COBleoDsYiw9S6YC
	1O+V2wK0tEETmhmHsxB3lg2kgHnSeJs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-NoXT2FPTOuC8IkW2wrI6wA-1; Tue, 14 Nov 2023 07:50:41 -0500
X-MC-Unique: NoXT2FPTOuC8IkW2wrI6wA-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-77bc720da87so476425485a.1
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 04:50:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699966241; x=1700571041;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+dtR7uxZYKr8ZF2Mvilnq0MwzlXpAsQU4Jpz/lAT/98=;
        b=S9UlyFQgPfg4pCp1pCp+6Net1BhZ5BVLHtiYjnxdNwQ+SUquWB7vxua1XxOxGbyUhF
         73WZz7BkrmwET3sa4BQBl8KV1wNlS6yteHhJM0LMLUEJEtuO/NDJRvyiT4F9uQ9ydLis
         8wrVGRmKbk3wuUhykqoMiyrQgkYaF1fXD0Y34CeoqiFgQHelo+odP/UbylK8NrnaC3ya
         OssZdoG3pM+PxydNu8W+3nzWhAVflrkW76mD8qMUIYSV3wOjB2q7lLXuHFBHeDTP1ZFx
         CBMTKWGVDGrDpmoKBGOxadC6QwLLrvJix1LBBPqRws+/SsC+NstGAw6k0NK+p8hT/vU4
         0ZAA==
X-Gm-Message-State: AOJu0Yx0wek7uXhu8Ur0cLstu6on8GE1o67/QgWeJZMqPM771dYrFjTZ
	YDXSPcUP7Cga/xGN8+LOOsdVdj8fL4g4RnUObqWPMG/KNDcFJVEN4ag/q4+5yRoBN7AKWHRjNXP
	HGNuE+nMBOBvR
X-Received: by 2002:ae9:f808:0:b0:779:e2f2:2be3 with SMTP id x8-20020ae9f808000000b00779e2f22be3mr1984102qkh.30.1699966241031;
        Tue, 14 Nov 2023 04:50:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2/zjHMfgKXBv77NBDBXPIwXJPe13B0ErZi3LiGA1sLO98BkmbiIkPxtcXMwHgeV07sNodaA==
X-Received: by 2002:ae9:f808:0:b0:779:e2f2:2be3 with SMTP id x8-20020ae9f808000000b00779e2f22be3mr1984089qkh.30.1699966240746;
        Tue, 14 Nov 2023 04:50:40 -0800 (PST)
Received: from [192.168.157.119] ([12.191.197.195])
        by smtp.googlemail.com with ESMTPSA id r17-20020a05620a299100b00767177a5bebsm2607897qkp.56.2023.11.14.04.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Nov 2023 04:50:39 -0800 (PST)
Message-ID: <3cfe0285-bf5a-4a0b-ae72-f5008c71d28e@redhat.com>
Date: Tue, 14 Nov 2023 13:50:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: build warning after merge of the kvm tree
Content-Language: en-US
To: Stephen Rothwell <sfr@canb.auug.org.au>, KVM <kvm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20231114141326.38a3dcd4@canb.auug.org.au>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20231114141326.38a3dcd4@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/23 04:13, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the kvm tree, today's linux-next build (htmldocs) produced
> this warning:
> 
> Documentation/filesystems/api-summary:74: fs/anon_inodes.c:167: ERROR: Unexpected indentation.
> Documentation/filesystems/api-summary:74: fs/anon_inodes.c:168: WARNING: Block quote ends without a blank line; unexpected unindent.

This reproduces with the version of sphinx in
Documentation/sphinx/requirements.txt.  The fix is
simply this, for which I will send a patch:

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index e02f4e2e2ece..0496cb5b6eab 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -163,8 +163,10 @@ EXPORT_SYMBOL_GPL(anon_inode_getfile);
   *
   * Create a new anonymous inode and file pair.  This can be done for two
   * reasons:
+ *
   * - for the inode to have its own security context, so that LSMs can enforce
   *   policy on the inode's creation;
+ *
   * - if the caller needs a unique inode, for example in order to customize
   *   the size returned by fstat()
   *
@@ -250,8 +252,10 @@ EXPORT_SYMBOL_GPL(anon_inode_getfd);
   *
   * Create a new anonymous inode and file pair.  This can be done for two
   * reasons:
+ *
   * - for the inode to have its own security context, so that LSMs can enforce
   *   policy on the inode's creation;
+ *
   * - if the caller needs a unique inode, for example in order to customize
   *   the size returned by fstat()
   *

Paolo


