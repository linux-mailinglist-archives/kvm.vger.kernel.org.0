Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7427BB03E
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 04:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjJFCVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 22:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjJFCVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 22:21:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E3ED8
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 19:21:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d85fc108f0eso2355121276.2
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 19:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696558903; x=1697163703; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YA+Cq8KKd5SLVssX1l4RlCcP9aKEvDTuHwUHfnMy3sQ=;
        b=Z+L4E3oUhFAGSLgAywc0kpzZzAgpzgvZMI4XgpBJxtGUnyKLGO7UWCEbB0mkbmips/
         0qElMp2EAZ5e7E0U7nE/yZLpN1MOCiwZ/bSygH9HleqIr1+yeuGYd0WDq0WU2fIQ/KL5
         ssQwhMeWQwQTyruEbcLI+haJ2ZIe/mYcKuMLmbkvoD+RLnufyyLMV/N0/W6cZMdjVzo2
         U+UNEe28hvG6yxrO4OwYJWEPtSOFgfgvoadCsrIEXZqXElfCCndmQOdE2cpm2T+7+NcC
         3OQeLjEhioAqTNGNliX6v6yLHuNPyJNgdlXsqM7VhQ7GnMjqVMO+aulKNZXKQ47Ha5ou
         NGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696558903; x=1697163703;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YA+Cq8KKd5SLVssX1l4RlCcP9aKEvDTuHwUHfnMy3sQ=;
        b=Dt66JX+U5FwkA4CjjCN9EgsAIcmehB1xd5uW6gW4YkRhtdkhwkjUqaD3N5hJbb+/z/
         1FhKjNhlgQC7H22R3/K4V6LzdqFwgfEz16v90MwahkWsQ9UnH5Xla3J9HyXWJO4kZHs1
         Ike6Vm7s3uVbp1CKdgwx6L6PqDcnw8Xu48vUTbemRDrGzHVntZyXPqHxjzfWxN9FBh5Q
         YE2v5ie0M5UG5Vwx9GnUOF0fDTKfCJQrgRZlyFKYqfmw1rIk/X5gktO3/XATOGtb1L2v
         EtkvAqU5wvQKXVOTmFns7HdoRrMoyYVzoHS1VZCy9sPzxYgGnGMiIbcl7HP4fY5++XCy
         5sfA==
X-Gm-Message-State: AOJu0YwepoaIGUBgwWTXp90j/J+HVO/F/msuqBQ6NwPUw/qKB5grUigq
        zJcSgt8tqY7frrzosaxgzArlWX4okuU=
X-Google-Smtp-Source: AGHT+IEmt68AoxtPnWuyaCCn+Zj/+0mc6WtKkThbxJBKMz7krdJA8UcNiwqpDXmY1FKyQxnWztdJZhkmuPw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8a0d:0:b0:d81:7617:a397 with SMTP id
 g13-20020a258a0d000000b00d817617a397mr114628ybl.9.1696558903249; Thu, 05 Oct
 2023 19:21:43 -0700 (PDT)
Date:   Thu,  5 Oct 2023 19:20:07 -0700
In-Reply-To: <20231002133230.195738-1-michael.roth@amd.com>
Mime-Version: 1.0
References: <20231002133230.195738-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <169655697465.3534024.7746001565902273346.b4-ty@google.com>
Subject: Re: [PATCH gmem FIXUP] KVM: Don't re-use inodes when creating
 guest_memfd files
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 02 Oct 2023 08:32:30 -0500, Michael Roth wrote:
> anon_inode_getfile() uses a singleton inode, which results in the inode
> size changing based with each new KVM_CREATE_GUEST_MEMFD call, which
> can later lead to previously-created guest_memfd files failing bounds
> checks that are later performed when memslots are bound to them. More
> generally, the inode may be associated with other state that cannot be
> shared across multiple guest_memfd instances.
> 
> [...]

Applied to kvm-x86 guest_memfd, thanks!  I added a comment to explain the use
of the "secure" API, there's a non-zero chance we'll forget that wrinkle again
in the future.

[1/1] KVM: Don't re-use inodes when creating guest_memfd files
      https://github.com/kvm-x86/linux/commit/b3bf68b66062

--
https://github.com/kvm-x86/linux/tree/next
