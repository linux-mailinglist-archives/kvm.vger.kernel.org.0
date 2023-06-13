Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2138372EAC7
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 20:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbjFMSWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 14:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238644AbjFMSWo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 14:22:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB6410CB
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 11:22:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bc8ea14f4eeso3952692276.0
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 11:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686680561; x=1689272561;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EXVuBob+0SnyKZatfXrUWZoqQLyDxveDSVB+zD1ibDM=;
        b=id85ldk4n8HN5QzD14071she5h8N1rHlmeqY3RWOE3md2iPJfHRvxnDZC07/3qpC36
         /BKhb7do2QF/t0iHzEB36e01IzE5zmaY9+HYQmZtVnx4ITLrCVgaPu8KU3SQBElzrASj
         uwNzZAf3EyFoOTQk2kBTNev4Z7pcOKlVpKSxF4eASDOwpWfI6P3aSj18suKF3wp7CLci
         Ot6p5k80XtOL6P67exHbAsKkSMBcKk7grY1unQ6K9fgX9imYopk+x6Gjnv7ZBqpDaVva
         bhD8VBnf3kyXVMTFvM3aw7tFnIyqwWyOA5rJwKDJd+GGiv5OM+YwSA88fzRkBUYdZy+H
         viRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686680561; x=1689272561;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EXVuBob+0SnyKZatfXrUWZoqQLyDxveDSVB+zD1ibDM=;
        b=b2nfB9zXMIGlKj+Q819zzKL6Q3j+e0Mj6agxzdygmUnRRDhOTl7kUTFNAnID6Nr80t
         li6kKiFeVCm6lEsejkj7zV6wxU1v2nAPYBtTLuGdrBvkGX79YvLZk/cs1sWuJjXs5mbT
         L9xStp060gf7nj4D6xdmnwsBs59eQzOHe3OwhpPJLlyqGvCkkg+AFE371sOW6srVBbDE
         6tzaSSlkUJkks0WRSurTGUB8WuvoN6Wq4sOb5rz42CizgBhT92f38sLvnBR4qmZ7O2xF
         jJECADKh7um05Qn41zWFfhSYeM4PTZ6SRSebozpglC8LznFRZEhsH82BJv/jbnjN3i0m
         aARA==
X-Gm-Message-State: AC+VfDz58fgnSqMkGDGfmFlwTn2lCG8vtHM222Y8X8mHppPEl4YTPJPj
        jgnCTvc2VAWAtos8sGnWMVS9HKTLRzCpQnQoHbSGA3CKpxOsQYHYzuIYiLL7oxUsJwwM4DnW9Lh
        ZnoujXe/rlpLE9nht/bVE2MblkPGBeCmO94/RU9imII0cQoX9bJyiFJVhEw==
X-Google-Smtp-Source: ACHHUZ7CM6p/5nCxeUfVQdMmxRHqJB5W0/BYt3xn73uGN+kqngA6b6vyk1VojGId5+q9gV7ht9oYEZxd3O0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1384:b0:bca:295e:f9bf with SMTP id
 x4-20020a056902138400b00bca295ef9bfmr1102242ybu.7.1686680561629; Tue, 13 Jun
 2023 11:22:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jun 2023 11:21:19 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230613182117.1942693-3-seanjc@google.com>
Subject: [ANNOUNCE / CFP] KVM Microconference at LPC 2023
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all!  The KVM Microconference for LPC 2023 has been accepted!

Proposals/abstracts can be submitted (link below) under the "KVM MC" track.
Very tenatively assume that each slot will be 20 minutes.

The exact timing, location, etc. are TBD.  We (Paolo and/or I) will follow-up
with more info as it's available, and as we ourselves get more organized.  In
the meantime, I wanted to give everyone a heads up that the KVM MC is a go!

Logistics: https://lpc.events/event/17/page/198-lpc-2023-overview
KVM MC:    https://lpc.events/event/17/contributions/1413/
Abstracts: https://lpc.events/event/17/abstracts/
