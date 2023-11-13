Return-Path: <kvm+bounces-1616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DCE67EA30A
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 19:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17671280CE5
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 18:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F46222EEF;
	Mon, 13 Nov 2023 18:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="XP5HoQ/r"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8F6224C1;
	Mon, 13 Nov 2023 18:45:05 +0000 (UTC)
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A48C10EC;
	Mon, 13 Nov 2023 10:45:03 -0800 (PST)
Received: from [127.0.0.1] ([12.186.190.2])
	(authenticated bits=0)
	by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 3ADIiKRh2900126
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 13 Nov 2023 10:44:22 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 3ADIiKRh2900126
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2023111101; t=1699901063;
	bh=FZE+FvSi6u4aQFLQvHgrOHd7TQi6rWLbKXOmD09TF6A=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=XP5HoQ/rQHS15agijE/mnW3jN8y4uCAoW8X5d8XFs0CUk179eFq5XfZchanqbWRMg
	 1dNreqvOo1zuUZh/Cisg3yiuyTFfDyfBKKXsNav4XBFDxISWs69itzLxvtfzynAgae
	 BIsY/BMBIQ14ziU737No8xPdvsyWFsjL14tgY92zW0s4Wz6Srwvvu4wNamTPrso+9C
	 PxJJLl6T/qmtDmITfvCS64AxrftdWcfgnLw7rNI4DtyANy9HkrzafVXeYLot/P+CKr
	 KfZcEJo+JA0pZ07T9SHlxFivjRwRjb5n4V3Q1F6FpHsAfrRWUU9HShUuJ3vJdE6KBp
	 4WHDAyICARajw==
Date: Mon, 13 Nov 2023 13:44:11 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: Borislav Petkov <bp@alien8.de>
CC: Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, luto@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, peterz@infradead.org,
        jgross@suse.com, ravi.v.shankar@intel.com, mhiramat@kernel.org,
        andrew.cooper3@citrix.com, jiangshanlai@gmail.com,
        nik.borisov@suse.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v12_19/37=5D_x86/fred=3A_Update?= =?US-ASCII?Q?_MSR=5FIA32=5FFRED=5FRSP0_during_task_switch?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20231113182947.GEZVJrGyMS4KzQafIK@fat_crate.local>
References: <20231003062458.23552-1-xin3.li@intel.com> <20231003062458.23552-20-xin3.li@intel.com> <20231113093742.GAZVHuZk9CGTRIfAWb@fat_crate.local> <3BFEBDE8-6F90-43A5-AE34-07B0ED0CAAAE@zytor.com> <20231113182947.GEZVJrGyMS4KzQafIK@fat_crate.local>
Message-ID: <78A17F3A-B373-4277-8D72-A47CA84E29D8@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On November 13, 2023 1:29:47 PM EST, Borislav Petkov <bp@alien8=2Ede> wrote=
:
>On Mon, Nov 13, 2023 at 12:36:04PM -0500, H=2E Peter Anvin wrote:
>> A resource cannot be consumed after the value has been written; this
>> is the only necessary level of serialization, equivalent to, say, RAX=
=2E
>
>Lemme see if I understand this correctly using this context as an
>example: after this MSR_IA32_FRED_RSP0 write, any FRED events determined
>to be delivered to level 0 will use this new task stack ptr?
>
>And since the new task is not running yet and the old one isn't running
>either, we're fine here=2E So the "serialization point" I was talking
>about above is bollocks=2E
>
>Close? :)
>
>> A serializing instruction stops the entire pipeline until everything
>> has retired and any stores have become globally visible=2E
>
>Right, we don't need that here=2E
>
>Thx=2E
>

Yep!

