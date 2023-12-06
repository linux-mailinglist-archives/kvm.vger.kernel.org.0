Return-Path: <kvm+bounces-3760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6699C8078DB
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 20:48:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B7E0281E47
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 19:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E80347F78;
	Wed,  6 Dec 2023 19:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g5qLmFoQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A0BD51
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 11:48:00 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-3334d9b57adso118016f8f.1
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 11:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701892078; x=1702496878; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YT1b51nW9x4n5/UPb1xMUN5rntY0KxjYvUTljx6Ob0E=;
        b=g5qLmFoQgsBQTUrwNuR8G9t8hpkc6JhFcXTTEjJJyuQsbudR5656TOBzlMZy9zeERh
         UTYCR9OsHkI2lnUW0k4PSI25oRTNU+kS6tDHqSNOzSyAUFwE1N6TNU0urD8AFbCtmr0D
         3VaF5f0i2kQNbokdXwzMzJqZvNOixRQVERzonKvJGs0LvQ2BwnibFzZKlRjBWYn0zw07
         tbS//SXKKRTr507dhzcJMpz/aBzUHH4BTpYYpUHbMBY/WNMzOphY0aB7bh7iEcE46qvg
         pEVXXOyKZaZzPc+GrxjgPUYddbP2whc8JR3I7TTJK9rFmcCeqKdRQMs/qTmauKY2Jkib
         8QIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701892078; x=1702496878;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YT1b51nW9x4n5/UPb1xMUN5rntY0KxjYvUTljx6Ob0E=;
        b=gAAhaZEL/ffX8O8l28HYngfCYCsWkKE/yPYG7xNQXNUT+MzEcnUkI4j4pS4gxnu1MN
         sw4THDMSeK3eRjnCx9/BvHiDI0O86HyWOPU0B/i2q9uGSu440OWSw2JPA2AcG6rgwRX8
         R+Eh80Mf1OmAJJ4roHxURg9lwWijPAazTDvirVa7Woyxq+woDSF1OP+kx46kPZGyn7lk
         B8hK7S16ln1UWEjMzCDuOqfJ4SIWkPmLeCMdWO+OVEb30LttEV3tVIZY6FFemJBFyhLD
         GXrLmwhoiTP5rDBH7wC9g59SIPmfym733nPtHUrtdwzk768UqDp62gCWQf5ZqB8QQlRQ
         8F7Q==
X-Gm-Message-State: AOJu0YwN4E52z7COMIHt6aGl+86URafQ3ZgVDLHCOtnVd6HhA3N0BIDj
	hM1xqi9OOzLqUqVZbDhHcc0A2YYxDEsa3SHMq9mvzg==
X-Google-Smtp-Source: AGHT+IHAwyoTP5J7OG6U+wcBRTF3R8R8kD7KZULCCYRyyqcAhA2n4V45Lyg780D277EB1x9ciS11nYjXAXGtEy9lyOg=
X-Received: by 2002:a5d:5258:0:b0:333:1a1c:50fe with SMTP id
 k24-20020a5d5258000000b003331a1c50femr806489wrc.59.1701892078525; Wed, 06 Dec
 2023 11:47:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: David Matlack <dmatlack@google.com>
Date: Wed, 6 Dec 2023 11:47:29 -0800
Message-ID: <CALzav=c=C3q9SwB340-mSJeT7FN55omeVZv4+LZiWwoaeA0Ufg@mail.gmail.com>
Subject: 12/13 PUCK: Post-copy support for guest_memfd
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm list <kvm@vger.kernel.org>
Cc: James Houghton <jthoughton@google.com>, "cc: Peter Xu" <peterx@redhat.com>, 
	Andrea Arcangeli <aarcange@redhat.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi everyone,

I'd like to schedule a PUCK to continue the discussion on post-copy
support for guest_memfd [1]. If you're Cc'd on this email it's because
you were Cc'd on that thread.

Requested Attendees: Paolo, Peter Xu, James, Sean, Oliver
Proposed Date: 12/13 (next week)

I can present some material on the problem (post-copy support for
guest_memfd) and the possible solutions discussed in the email thread
(KVM-based demand paging, file-based demand paging). Then I'm hoping
we can discuss what direction we want to go in, and what information
we'd need to make a call either way.

Please let me know if you can attend. This isn't super time critical
so I'm fine with rescheduling, e.g. to after the holidays, if
necessary.

Thanks.
--David

[1] https://lore.kernel.org/kvm/CALzav=d23P5uE=oYqMpjFohvn0CASMJxXB_XEOEi-jtqWcFTDA@mail.gmail.com/

