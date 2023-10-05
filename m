Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127167B999E
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 03:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244354AbjJEBbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 21:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244261AbjJEBbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 21:31:12 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C216FC1
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 18:31:08 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-2776a4c47c3so344046a91.0
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 18:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696469468; x=1697074268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xVgovfFIHrPk2yJk9qKfK1DGLvP2krMyyp9FPm9O3VY=;
        b=h7NC6YjyQlE1CZujbJQhIC7N5KAJxyRgDikHe6GC5Y4tkudj+5gFG22ccGipW+Xvau
         vaB4904fZp45Z6Uqy/XDMbTg/UIrDFPmykqTBATkrPf8hFIVHIku7x6pSH+68xFV1h0+
         43WffAxQ/TiA4ia6c24p6zXzVyG9yoqOSgHUyCRkS0lbGPPDa7i/VhNRZ4rkqBTc/ZUZ
         xCqpfbvGdYh5FJE/KzBPyoLov8iColx+Sabeyfkrxm1GiAW1tNztH1dC/O+y7YHYZoJ8
         r79/7gQPjsFjGvSZ9mwOBZCksH6EoNxSDt0/r5+wor2aAXhyGUmPaRJ+NDF63PKbWi36
         nQ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696469468; x=1697074268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xVgovfFIHrPk2yJk9qKfK1DGLvP2krMyyp9FPm9O3VY=;
        b=Rtz6tePVeUoESuJ2Rz7EGChz0bRTlKuWPaq5cWjWFEZL1dfFKaMoy3uLkoJwbdR3zD
         qipO5R/UfMxwKD3LaYwpY5O59mZ/8SCxlT/nEnR/sPaGy7l2HBJDdcqeOPDSMvY8e8am
         PUHlGpgHjTT/zTIF2zTpeYgrI4MbvcreugU3tM4rfERmskXi+xHzbE3sFwthwYk0h9vF
         zTsYHvwTtYsLMLuMmg9LYnsHs9bpv+WDyEsTLkvX+o+nAYg6cx5eXvGOAeT1vUgJQnT+
         Qhro4l/cVQb9dp7Sbvwo6DwI4FQUm6m7FQJNfViY4XTc1NAOfw4MeE5jyLCd1ysIYCv+
         BRaw==
X-Gm-Message-State: AOJu0YzQhsD2JgtdJ6jqwXtOoTg+jxrlnPFdD7zliJhxemdq491BJbxN
        NOYHXUTygGYamchspnxPnxYyWitNAGo=
X-Google-Smtp-Source: AGHT+IGc58/2Obt5Pktt8dZ8K8fc1F0uMlZNqn3fpnqV4qr7ln7HEXjnOdhXKzEDxYv0JYmd69aVWml+xEU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:de91:b0:277:2a7c:7faf with SMTP id
 n17-20020a17090ade9100b002772a7c7fafmr63944pjv.0.1696469468246; Wed, 04 Oct
 2023 18:31:08 -0700 (PDT)
Date:   Wed,  4 Oct 2023 18:29:29 -0700
In-Reply-To: <20230914094803.94661-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230914094803.94661-1-likexu@tencent.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <169644819880.2740563.9902355041421269964.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Remove obsolete and incorrect test
 case metadata
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Sep 2023 17:48:03 +0800, Like Xu wrote:
> Delete inaccurate descriptions and obsolete metadata for test cases.
> It adds zero value, and has a non-zero chance of becoming stale and
> misleading in the future. No functional changes intended.
> 
> 

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Remove obsolete and incorrect test case metadata
      https://github.com/kvm-x86/linux/commit/332c4d90a09c

--
https://github.com/kvm-x86/linux/tree/next
