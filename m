Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795CA16B647
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 01:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgBYAIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 19:08:17 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:36704 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAIQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 19:08:16 -0500
Received: by mail-io1-f66.google.com with SMTP id d15so12249945iog.3
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 16:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yYLHirngUHxt10qFoU9xmupylPxKXSewlxECiHVcCbc=;
        b=pdVgPiWKRIZ6FGDifzN+jO7VW4qmMUPDK9hEVvS/Uzl7iTkfQxBqNCYbyruzNjkH3R
         FUsq75ZEMBVuEZmMvqJlBUHbo+HQ9+bhK97Nb6Qn8c+k8WLWDt6OcSir14JkDnVim3VL
         dAhGAYEIq3EX7SLhpFZDPFNtOPhCNiVDp+YX66sO+jg2+77959SfeDUcywD9q76Qcb+n
         SXXL7OVxUHg7VJvpXpLbuUq1cGDk5BnhUbJeWXdWWsyTnXEW2RxfLnY6YvR6kf7QgwMi
         G9Ug6sDiaWMxQY/sQIweYBoEk6YUqtOHp1K0Y5poF5WyQOhiz1YMlOp3J8K8ilB1XVBP
         oXZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yYLHirngUHxt10qFoU9xmupylPxKXSewlxECiHVcCbc=;
        b=eszK9y8A25GYinZrs4mKHj+NyRMhmEj3TiYrkpl1vOKi/KM8x/VItQrvdHdDK+9I2Q
         91QeWEWmew9ceJsC5lL3WAzRSl1ouWkkfv5a0bGCtSzXJLx8V2LwoOVPNnT4bWH7XSVB
         43ZgGFlNY6gw/NbKhOSDGb6qPu8yFt0X/XxXxa9tojPhBhXLesHiti2khSGGTOXj42+l
         Y9g9RZbji+0nGJAoE7NT9V4nS3GlcOjgFyHFF7xT/8bxFMgZK584WxqpBzM1G8NAhCsK
         bJmoJo1MDxxSPpPW24hUDM3UlURAo1dL3dlCmJLUCLyLGjv0Sx5B1G1lIoEUhYTDpyf1
         RZQg==
X-Gm-Message-State: APjAAAWpCws2StnR7XzX0joZeHh9SzNWUR9Q4jbEf8K4OnQHy1iOMM8Q
        6PbGQiWFpBl50CGhXaxOPuyl8ZgyINDZXyrbSzSMYA==
X-Google-Smtp-Source: APXvYqxTkakpljUYeVp2JLg4XJzRu6x6qf4LnVcCbcWcEYJgPZZWbcAnu6mgIc2I1Tomu0LoUoG8bchFDT2g5USxwpM=
X-Received: by 2002:a6b:ee01:: with SMTP id i1mr54662261ioh.109.1582589295859;
 Mon, 24 Feb 2020 16:08:15 -0800 (PST)
MIME-Version: 1.0
References: <20200222023413.78202-1-ehankland@google.com> <9adcb973-7b60-71dd-636d-1e451e664c55@redhat.com>
 <0c66eae3-8983-0632-6d39-fd335620b76a@linux.intel.com>
In-Reply-To: <0c66eae3-8983-0632-6d39-fd335620b76a@linux.intel.com>
From:   Eric Hankland <ehankland@google.com>
Date:   Mon, 24 Feb 2020 16:08:04 -0800
Message-ID: <CAOyeoRX8kXD4nHGCLk=pV2EHS4t9wykV5tYDfgKkTLBcN5=GGw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Adjust counter sample period after a wrmsr
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like -

Thanks for the feedback - is your recommendation to do the read and
period change at the same time and only take the lock once or is there
another way around this while still handling writes correctly?

Eric
