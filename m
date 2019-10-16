Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8478D979E
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404348AbfJPQj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:39:29 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42466 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388542AbfJPQj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:39:29 -0400
Received: by mail-io1-f66.google.com with SMTP id n197so54582210iod.9
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 09:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rqcsZwJUXTVhix3ZtuIDUey2+iFKqsDJTqHrmcJMzY4=;
        b=Da2IzUkmMK/JDKlzTf+4T4wm44+yvlf699YPJ7iQU+/s4LGwImLRNPyvgykTANQCOT
         grAVKqr2BGP3mPx7/LGbDVST8eMwu1EjjvqPnRwbkIAx8DUDpSbTDPdcDYmzY5ro0y71
         5GRfdokkihnwuCVauqSF3mFtvHD1L8yXTDw3dv3f+waYDA2AaodheQ9IzTa/3nGqhkC9
         dk4qr68nxwqUHhLoljYR40IovgJeK3qmLHLV67tbxKHK2TTrCMOli84AWhhG2JJ+FWrQ
         j5OfANOrHg3YLwKIeQLgueYapu1AgAwQnD6UdP0Z034bSKwfi4HAh+WdrRRVmfXJfzab
         qzMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rqcsZwJUXTVhix3ZtuIDUey2+iFKqsDJTqHrmcJMzY4=;
        b=b0POPd4uNJ9ydSiwKsHmM3h/+7uyFHk7Qm/xCh9YvC0b5lp9W5QVd4dWLbuKxI/gCM
         SSPdGURWbD912L4ubIwmf79F5JfqsQMz8Dqr91vcUov9O4amnWl7JTAARNcqUGUvDegu
         vzZS+0iF02B1SDCqpW7Ln3tW8h0vyq1ZsXSoglZxWGW2tOclFzjwlpNlU0Kaz+NkJdIB
         M0cH5dfW6tiUkm+wF+wq+BmvBZrWX57uXnO1HHBsOFyVTisblk1834nHFeJO2jdfLXb1
         zPpwzJKdP7nsQS7M7vui2ne7T0V3fL19CoNmF0a19j4rpcToQPSbC84EMgS1ugLMieu8
         oxxg==
X-Gm-Message-State: APjAAAXqivk4vP9h2t+ol8fkfJ9ONkXg8KkEGZlevMSrp+P7C1Si64mF
        orTKdFqSq2ruaj+hSRbbnEhhnbLP/j7gvR+KUeld9A==
X-Google-Smtp-Source: APXvYqyZCiTBrmaSQRw7+AG7gvbT+HupUE8vQnkxE6666u2aRv/5QdkILl7x5lEl04TRvkLIL7Rq3i0213GBxDTRqWI=
X-Received: by 2002:a02:19c1:: with SMTP id b184mr42559098jab.54.1571243968266;
 Wed, 16 Oct 2019 09:39:28 -0700 (PDT)
MIME-Version: 1.0
References: <20191015001633.8603-1-krish.sadhukhan@oracle.com> <20191015001633.8603-2-krish.sadhukhan@oracle.com>
In-Reply-To: <20191015001633.8603-2-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 16 Oct 2019 09:39:17 -0700
Message-ID: <CALMp9eQ2xCx6++UaqoKkm9wB5FW8OtYLVrAJ-y-qD1tGgJLuuA@mail.gmail.com>
Subject: Re: [PATCH 1/4] kvm-unit-test: VMX: Replace hard-coded exit
 instruction length
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 5:52 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>   ..with value read from EXI_INST_LEN field.
>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
