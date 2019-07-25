Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B301975ADA
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2019 00:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfGYWqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 18:46:06 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40008 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfGYWqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 18:46:06 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so14201101iom.7
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 15:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Lxk0Ae7eDDKEWg9SwJtgC0ktt4wB85YsNwhNQopsQE=;
        b=vn+If9uM7OK/c4BDp83YxyN8Hqm+Tju9v0u51Z/IQPMHlSCtaGPh5Q7X+e425wh/+E
         LzPaMmqdsmNoA9vnzbl/axrZ91lKio/M//eQGwJjp8xTx6CJHGpKqd+p87GYAE1DAXJa
         A2JX4fdLAApFH2Ycb20E/LxUli/6aYwPe6oYcFE+I3G8B4x+EQqwvVYabJ6QSrKnJ8LI
         Wefkga0EaUOcI1Qm4ixTEj1v+dRWsQOSqY9qOBgr+EU9OxiRXWpP2PLzSJI+9NnjnhCN
         vt+74ucixxSRr8D4oGhayuOOYzuRqsHccZmvP4PEML1DfvB+onpftSMxJWAg5N/Gs+v/
         g3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Lxk0Ae7eDDKEWg9SwJtgC0ktt4wB85YsNwhNQopsQE=;
        b=R0lUMxbnzNco/rbfJNr4neoTzhJ2tb/Q9y62QnUl8G45fPEgHfgjHJigcaZnmHZPvG
         JZ40nFyPvjsdDIKkS8YyveOjqanSAyccXndlTr0Umzt2NpSU8428RMKAllxLAQRC+PI+
         bFOWHLC5JwSZGMrRUwGZYpy8wknMnLsvd7AqrkiIfdIVQcFEjHSlqQ3WQhFq15s0D/L6
         nO0HpecYtM+dwZ5DIlXo3ARFluzzUk4rowbC6RFvO4lPfrup2n1i3ykDMG8VPXIWQFH1
         Q8hMVqzMpfxXDyWlVJXAIpL2a0FpUdWiqB0Wm5Et/uR3gj3SsYDtkmdc3G2jTOFdhCkb
         0GKQ==
X-Gm-Message-State: APjAAAXs3LyhLFJxtPHjaJbRdMiKI645SifQDXSoXX38K42H/YyU1Baq
        7HiEji/luoxwREdY07pUgjvFfl4Ccg7nNNz+cp1WZw==
X-Google-Smtp-Source: APXvYqyty0QNo+axJfjhDdYuiK/A/ZWfJww001uTTQdL+szCi8qIhWSK/XO2ZKlcUqCvUT19NUF+enS+CvYkAcqMzbw=
X-Received: by 2002:a02:9004:: with SMTP id w4mr69525400jaf.111.1564094764872;
 Thu, 25 Jul 2019 15:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190703235437.13429-1-krish.sadhukhan@oracle.com>
 <20190703235437.13429-3-krish.sadhukhan@oracle.com> <20190724161247.GB25376@linux.intel.com>
 <d157a449-c31d-a7e1-b855-60541aad8501@oracle.com>
In-Reply-To: <d157a449-c31d-a7e1-b855-60541aad8501@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 25 Jul 2019 15:45:53 -0700
Message-ID: <CALMp9eQFcYujT9di_qrqmwzMy8sXXY0bJqO+pdiMSd1qQtFNsw@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2]kvm-unit-test: nVMX: Test Host Segment Registers
 and Descriptor Tables on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 25, 2019 at 3:32 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> As an aside,  I am curious to know why the hardware threw "invalid
> VMX-control" error on bare-metal.  My idea was that since the hardware
> checks VMX controls before Host State and since bit# 9 in VMX
> Exit-control is unset, we are seeing "invalid VMX-control" error instead
> of "invalid Host State" error.

See the SDM, volume 3, 26.2 CHECKS ON VMX CONTROLS AND HOST-STATE AREA:

These checks may be performed in any order. Thus, an indication by
error number of one cause (for example, host state) does not imply
that there are not also other errors.
