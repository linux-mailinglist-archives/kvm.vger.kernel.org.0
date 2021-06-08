Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4A639F125
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 10:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhFHIoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 04:44:13 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:59199 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbhFHIoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 04:44:13 -0400
Received: from [192.168.1.155] ([77.7.0.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MC3L9-1le76c2g6X-00CTID for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 10:42:19
 +0200
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Nested VMs
Message-ID: <edd7c5f3-be46-4a88-7e5e-d76f3aa8e483@metux.net>
Date:   Tue, 8 Jun 2021 10:42:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:l53Haku/fEiOyr4hRKMJ//EDx82KWurMIbl16oHUIVx7y/wd/PJ
 dm/Peeh+Ka9XLHFZzxlbbf6dr04C+PU11eb/nmnbJHpzQHmFMx3m1f4xpe67p5TLvGzhk5o
 qf4ZKIPRWg6Xptzcxbmo3ugbUsiWpXTeiJXoSA6WRnghXPuEiqPIZ0IiSRwQcEgGv12uTWC
 99Ahk1/KvvrEfbego0aPA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Xrv6jvwKiec=:09iUrxtysbk2CmHDkjVOeZ
 8CmWOvezVTyYzA2tA+9WUlHkzuLDguYQG3ip7LxWkihH9jXprkedqUJAmHWwC12IJ/uTDm6kr
 742coYt8VVDl8Tiz/yckfo4mvhV3apqS8TrfJue70t3t5yCnc1/8L0dmCcUNfFR34ONP0p0I7
 neZzV7BBjDFF3MERJ7Dk3jrjxiHVgKOeAQOXWXTLASwvuG94c33atIZl7oa5rWE5FigtAn8Rw
 m2hrQ4uyaU+iIA+9S7lOzcgA8ZN0SSl0hFi2IBRNwbhj/9jSZC3qSvn7sfz++SW/Hm/mUtHaB
 ynDFa+42ca/mYRJRhSvOVlTwzBSrJzwBFp7B7JamHp3UjrAFmamgfpcPbKrXZhvtacr4vc6s3
 aYtdWCgewB+cvwoemh6OjKyuyzRx0D1qNm/5E7kuVx7zPLZX1V7Pxc6kzuAUaiXs9MfVliL5N
 IdpNWO4jFaBrqu6g/zFzpXm8eHA4sZb/+mGPkAk7xgY3Bp72lWB4CAOgysODqZMloInHU9oIq
 xH9wzV50DTDSEh/kxULLAo=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello folks,


are nested VMs already supported, or somebody working on that ?
What has to do done to make that possible ?

What I mean by that: creating VMs inside VMs (even inside VMs).


thx
--mtx

-- 
---
Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schlüssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
