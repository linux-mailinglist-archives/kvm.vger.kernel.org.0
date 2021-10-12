Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66D842AE88
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 23:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbhJLVQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 17:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbhJLVQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 17:16:25 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35B7C061570
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 14:14:23 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id z126so978808oiz.12
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 14:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=19GxIsR+j41et34QE0NnjcKf9ZQPSWYggmI9gWAvZGo=;
        b=sql8+y9ENjfsJ05F7DhDvrBXawLyrxY00O/LH5CZ2TspLqHujYoBJI6lb7kKcKjgub
         znDYUpIU12H3PL59n3YyjbFs0CtJhS4LbJlJ5r9BkdceKmYQU4Kuqvepkijdm0P1OVPS
         JK05GvKxj0dwNjZ9a8bho7JDgmqIyWvy62z+gEbQwFKObRhZ5+rcr/ebLjQFrjtU3ttr
         GCv2MsPnqFdbUFtrhE0P6zmTQO1We1dQEGtpDsFeBE37cPhQ2UHCHEMuBe+zpIoIsxh7
         Qsj7E5rNJDfBR+KJaRs3vDWX2XEtsLefXtQxHepoW4sUdUWNDwp77KUxbn/vIZgq8fty
         TTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=19GxIsR+j41et34QE0NnjcKf9ZQPSWYggmI9gWAvZGo=;
        b=jvKzYs6sZe3t82VOU13JIwJ3XbxH+SkpBwrkDNcYIkv54PGm7gKAP2vFHeg33OFHTD
         n51Yik2Z/hArTS/+Yv/A1KtO31kfgWcaKkUpj3n4sFcT6R1VbF1ILSspMYTIxJgryjYP
         Nnt3DWfrrP2UjCjBU23HRCofqWf23Duj3EBnigoP+yfKSk8FFE8WvJFHci+bNNe3UxrF
         7NiyDsjIvCQgdbFzZAy7cVDp4i6JfMgUrBK0s66cpOaQyDx85XQ9bh8uwuvFVFTuYeMD
         fvUVGBP1+JXAiTlV4iIlwKldINzb7W44yjv+9TCL6Mw4Pv1IXYNsRJxUpdOzylXtpVrh
         MSCg==
X-Gm-Message-State: AOAM530i1mjiAV05ACjOZPhslR6wGV4uvfL6HQREwcrIsLLv3dGLTa1P
        UzaeonLY+1XN+ygJWorDwT2gn5eGsHnHIJWKV0KwaA==
X-Google-Smtp-Source: ABdhPJwNK5w+d5svxsHAm2PvqGvJvZTSgZXwvVs6TWtD2ierds0TtTagKISxCYK7OlGmcfUJVgv5ZoF1pkcQUTdHQco=
X-Received: by 2002:aca:b886:: with SMTP id i128mr5171854oif.2.1634073262936;
 Tue, 12 Oct 2021 14:14:22 -0700 (PDT)
MIME-Version: 1.0
References: <20211012174026.147040-1-krish.sadhukhan@oracle.com>
In-Reply-To: <20211012174026.147040-1-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 12 Oct 2021 14:14:11 -0700
Message-ID: <CALMp9eTaGfDyHn2i=fT51_GtmLmF6cXa6h1Wb_s-f=8Me1wFtA@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Rename vm_open() to __vm_create()
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 1:43 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> vm_open() actually creates the VM by opening the KVM device and calling
> KVM_CREATE_VM ioctl, so it is semantically more correct to call it
> __vm_create().

I see no problem with the current semantics, since the KVM_CREATE_VM
ioctl *opens* a new VM file descriptor.
