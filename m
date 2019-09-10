Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B933AAEFD4
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 18:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436879AbfIJQnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 12:43:20 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33367 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729580AbfIJQnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 12:43:20 -0400
Received: by mail-io1-f67.google.com with SMTP id m11so39076321ioo.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 09:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SE+Fy0jA2VWvHvuSuV3hOhDeU4ZzxWu7rYGfUyygOq0=;
        b=NGoHjKW5RF/RQ7DWlmKTReZEQdvni5I0h0NasC72/OXkvJhXC4Mql3MqLiebBd7wrZ
         1hD08PN7FoBE122TUzeOa37vyUWrPhMIo5r5OwVRdchmYEqXxoqXf8oEkEr/6lG6KZCs
         qaOaa7gt5HngSr57NaXW9yu4dwVE8Wz81gzSi7VK/I4FpJMFiEZALzVxh41LU6J/pUoX
         lRsYAEpekpwKa7q5PE3cxmkvBDNFXcdCN72OKMJ1W8qI9Wiwh4WOVdFP6iLdVOxLz7W/
         BamKJ6+jXjzAEkj7OGqGPJLxrNAJB6synhRgvDo4Bm/HX9+iiFmJe7sWNFwUnU+PDwNC
         burA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SE+Fy0jA2VWvHvuSuV3hOhDeU4ZzxWu7rYGfUyygOq0=;
        b=kAmyd/jcXNptOpD+LDp2K4VOWAUlnTKLiKXyT2wbxLwTF18Fw5qUVWuBrn98SlnEvL
         2Qojt/ll4m2+0S9UqaMGMBgZ3VtqILny1vA5fzy+/xhY8dMnOZHzmVlGYi35xFdd/eSo
         79Eufs9WotTdpfLR8//mmgn9AkmLtBnCn5kn2sipGkbPa7tpvBqLEG4Niiu2KdfO5xMt
         d0eIGmr7WSBlGenD/WEKmA5D1KGR7k9xjxltQIz4zZAC7DFpWGpCqiSx8T9hM9lk9eWT
         4ciwg86icuUMJCAuvizQIzG684WsuaLkQWqRIJjA/WM69AI1+zJmYiwCYjHbCqP1bwKA
         cSGQ==
X-Gm-Message-State: APjAAAVggl7+y4GMIGyzgH3yzFa6uprpeUpC0oG5I43s0iR+Ic8ki4IW
        bjBtMuxblYfr9lZvTFzMi+LAqrec4rN++P2AoicnGA==
X-Google-Smtp-Source: APXvYqySoTpXKtX9ARrhLGHtsfNdO5BCg/LwrjRgR3KYwmzgBlV7ZNZZ+OeFXFl2mqDBhCSYdRVtbhTwf830FMx8Zu4=
X-Received: by 2002:a5d:8e15:: with SMTP id e21mr453075iod.296.1568133799055;
 Tue, 10 Sep 2019 09:43:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
In-Reply-To: <CAGG=3QUL_OrjaWn+gF4z-R8brR2=3661hGk0uUAK2y8Dff7Mvg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 Sep 2019 09:43:08 -0700
Message-ID: <CALMp9eTm4sbr2GK+mM_ibazA9i9d4-eBcMhtZmfTf6HQbbD_Bg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] lib: use an argument which doesn't require
 default argument promotion
To:     Bill Wendling <morbo@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 9, 2019 at 4:12 PM Bill Wendling <morbo@google.com> wrote:
>
> Clang warns that passing an object that undergoes default argument
> promotion to "va_start" is undefined behavior:
>
> lib/report.c:106:15: error: passing an object that undergoes default
> argument promotion to 'va_start' has undefined behavior
> [-Werror,-Wvarargs]
>         va_start(va, pass);
>
> Using an "unsigned" type removes the need for argument promotion.
>
> Signed-off-by: Bill Wendling <morbo@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
