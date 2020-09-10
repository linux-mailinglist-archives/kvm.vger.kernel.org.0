Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC1E263EDB
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 09:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgIJHjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 03:39:02 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:45331 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgIJHiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 03:38:54 -0400
Received: from [192.168.100.1] ([82.252.148.206]) by mrelayeu.kundenserver.de
 (mreue108 [213.165.67.119]) with ESMTPSA (Nemesis) id
 1MuDTn-1kWIPW1PIL-00uXuW; Thu, 10 Sep 2020 09:38:35 +0200
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Joel Stanley <joel@jms.id.au>, qemu-trivial@nongnu.org,
        qemu-arm@nongnu.org,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Richard Henderson <rth@twiddle.net>
References: <20200910070131.435543-1-philmd@redhat.com>
From:   Laurent Vivier <laurent@vivier.eu>
Autocrypt: addr=laurent@vivier.eu; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH 0/6] misc: Some inclusive terminology changes
Message-ID: <fc0df054-2212-df74-f561-d52976870e55@vivier.eu>
Date:   Thu, 10 Sep 2020 09:38:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200910070131.435543-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:3XPYXZnEL9oBPvi6dynCc9QtpVdL2UdAuLgu56r8dUYGYYgIE/w
 TDtIb9kjbb+hq2fYweKecxQ6MfdStqf36I8WOi4WEaIkplEst799DqjCnUw7niZOYAZgzvj
 NrkFUMBVwdyQUDwlg0L6VFQ5ogU0uRayMkhaMsUoIoEqO9V1R325jTPUMnP+ZRsGboLaQyY
 CfWleSDitg5zEMMTV0GUQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:q+hO28sWeus=:Im/mAeAzGp3eHnfvBbfJYu
 UHOGR6hRqEn+c5SfTGsvsF1RYgm7eSzvAKvHBHDaWAXHxKinfVZQMhuinKK3jlDY8ApZR2RqY
 Qcceuylgu2LzSydkVDncHS0tzt3yh5/XYgqmGD4BhC0K5csjd23tECAjia03fKKkY2zOQ/oPv
 Pmv2iKTN/LA0gFpWpY4kmsUUICV7mhBjIhU6DDghaMh5OAr13MWvAGhZxraVYycwLW6rVdNqX
 DU10dwLWmNTk4t1xL87gVoO7nJf889QVtQk31dQDWP0phWQ1BKQmBppN573ccrVjVQfP7e/Eq
 0FbTGJTxtcIHkEk4ZDgfqKZgBDax82jge21GY1Lcp9+Fbz9TPZGnXNQUPM+npxHNYwFkW3s1M
 ernksuYMhk9GG638VldG8MQ5q+UcMs8MRL9SCJkLAiECmVoBob5q7R08wykPyf3IJ55Boj7gS
 j6jLZwgclCJm+oyJCsba1RrGHmujJgajSKE09cOHT+B+uUlzuPFPvRqwd9dH8jq0d7HXoOSZz
 5WOqcWuT2sg2l3uMeJiT9gcxtDXwEkbdtQ04U9FFtDxHhUPV44/LMcpQH7aVu1SqTP267kTbq
 pBbDErgrnNo/eUgnd911qgt/XWTpy7mcQejHnTX33sv/jEq+6El/CH4rPWQv9iXyiUNgLJmeW
 W6x/4sTxmVf2ghWzViQ+QnY0AtXJUnAuInzvaSyHYEz9TNF55GrVyMseN1knFSwpoehaFsfIR
 JcxP1iLQFfsLSotnzlLKPOr3FAyhsnEVJo0tO45Jf04b2h+3f86QYnv4qT5ALgLmDug24vhSJ
 4Fy1l78ZUbcVcjMuGLBAkUCM8rrUYDu3ZLJwpHbmyN9Aep9S95VZaFBdivqdk9AK1GDn0tM
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 10/09/2020 à 09:01, Philippe Mathieu-Daudé a écrit :
> We don't have (yet?) inclusive terminology guidelines,
> but the PCI hole memory is not "black", the DMA sources
> don't stream to "slaves", and there isn't really a TSX
> "black" list, we only check for broken fields.
> 
> As this terms can be considered offensive, and changing
> them is a no-brain operation, simply do it.
> 

These changes are technically trivial but they are not from an ethical
point of view. I will add to the trivial branch only if they are acked
by their own maintainers.

Moreover, I think we should have a project level guideline before doing
that to be sure everyone agrees.

Thanks,
Laurent
