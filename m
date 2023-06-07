Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BAB72513F
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240319AbjFGAxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240047AbjFGAxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:53:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90934170D
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:53:47 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bac6a453dd5so7996991276.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686099227; x=1688691227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c8xwcfTGimQdH0D/iS4uUCymviJ0wktBitdRPQrS0aY=;
        b=mZP/teWeUDo92MEHX67fJ7De+ha5Rs79TULmhyNcRSjZoGJs1GD9OJ4znOwjlNtfGg
         a5CYIsL8MHhX+bjDfD6iX9J5POFTAhsQkWF9mlnVRdnGhu/ZpUejTIEYGyBl/IaX0cBI
         zSuiqeEQKW/wUTS6RT0HPfpW0nj3ORLcDz1o/3DActeRxym+Bqd/jf/HEPb7J4Cs8L9V
         YnhH65K1HhHTvaMYcsXq0JvSl5/y7mFjqFqFuBW3rA/eXu4T3/oWQ+0Epp7CrLEFCC3j
         jyDGAA1HyPZHc4T8U+IOUHOkwwVbozwfYrjXk4/WASvoOA22BG9Zf8j6ebWV4I4BvdEC
         HJRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686099227; x=1688691227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c8xwcfTGimQdH0D/iS4uUCymviJ0wktBitdRPQrS0aY=;
        b=gpYgVWHMJLup3Dt0IbQPfWiRgkCt8/Ow4kFkxT8ILvd7tqVI4LZvzYW2JdLgnGUrMZ
         ohAjhV2t0InW3WZaJtBfEM3BY76H88ekeVprdUswIWWPJ9ftZwqGPoT3LH+iKfc2NEJ8
         TsrxU5XGWKikW+zG7W5rUORmPVj34/+0+L+zTtSECqRz3Q8uIgJPzuFQ6hqz8a3F16Gs
         qAksIj2mTEECt+glOnq8FmTjPN4NqV+b9JHmKf3/+vo9/zulb56Y3FhHFnFMhAPX9Dq6
         D61pWDqb3trTibygVjtAB9U90s5oaRRR1XfMblJJoBZhHkPvj9z0+g+2tP47fne9dReg
         Rp+w==
X-Gm-Message-State: AC+VfDzL8ZE8YTjM4r+WJQ7fIRy7mHRTKVITkDQC58iDjAycZDSTvaEB
        9L2TJrxq0C3ttU6WJjBdOAn/mCYO9aY=
X-Google-Smtp-Source: ACHHUZ4hatBJ+vEIgAnEIVEUUXh4wUfMVuj8wSWh5Yq2uOW8tpr8uqTUj2x5ZR9uSlxot06sNWAFMK1bduM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3203:0:b0:ba8:45d6:dd8a with SMTP id
 y3-20020a253203000000b00ba845d6dd8amr2052367yby.9.1686099226871; Tue, 06 Jun
 2023 17:53:46 -0700 (PDT)
Date:   Tue,  6 Jun 2023 17:53:40 -0700
In-Reply-To: <20230605200158.118109-1-mhal@rbox.co>
Mime-Version: 1.0
References: <20230605200158.118109-1-mhal@rbox.co>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168609751674.1414984.14463483793083991599.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Clean up: remove redundant bool conversions
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 05 Jun 2023 22:01:21 +0200, Michal Luczaj wrote:
> As test_bit() returns bool, explicitly converting result to bool is
> unnecessary. Get rid of '!!'.
> 
> No functional change intended.
> 
> 

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Clean up: remove redundant bool conversions
      https://github.com/kvm-x86/linux/commit/e12fa4b92a07

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
