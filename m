Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3A31DE362
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 11:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgEVJmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 05:42:21 -0400
Received: from mout.web.de ([212.227.15.4]:60039 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbgEVJmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 05:42:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590140535;
        bh=MKYiq5Sp1KMcCd7UJd3BkYZ0+IXM0YIHV3p4p3MDECU=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=BHFs04E+hswktYe45EHT3IHDl2L+J1QlV2Of+iHrH9X0jk4Hgs2B/6UMXMagi7A3W
         0jjcCc1btvEOlujY+pYYpe87mWSmO1VrSSk4p3XJX/aauBf1h+EZqffd7W5xme0FZ7
         MGrFcOQxtoBfRcjIMU2hXmKSNpvJEGG+d74jiclo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.165.155]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N5CUb-1isena20zl-0119Qm; Fri, 22
 May 2020 11:42:15 +0200
To:     Qian Cai <cai@lca.pw>, kvm@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH] vfio/pci: Avoid a null pointer dereference in
 vfio_config_free()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <74c0fac5-fe3f-e1f6-672d-3be4a8945426@web.de>
Date:   Fri, 22 May 2020 11:42:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:qOSyTnymd+d6xaaDBwrKiBqGknfKfUVmir0qs8TAGvMUpDbbJ43
 aCEMihLPSh4X7yq6YPImbzxVMBBljUV06A8PCPaCSvfcTlyMydX6YelHG5bos1W9G+Zo/UQ
 +zAfijCnfnXyGGRd/Sgb7QKj/caPQH6LdBO51lzHf8+cdSdL8bLT6hdv5HG/JsRDK3gnsqc
 gF23z5nzMMHpQ5KwBpfjA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cqSOM2ILvSM=:yJqwMPhSwjPl4eeiRmBcVV
 CEMh2CDbVnOWDvN9bzvyjC/vXy3gHhsACE+WGPORMEu0Uw6Mh6vI/KXxzu0ooEfuj4PfiIMQt
 5yf1tvIYpMkA7r4Kv5xyVdMEuJDuObKCVofpJXjZLehhek2OlpyWrX50lZuTBKzjKISoXfruE
 YnV1l00DevJA+j7ViA1iXez6AVbw7+nbtT9JLuy56QwlvvvWOrxqM6t9RCcON6sPxfQB3yd7y
 FXqVVpt9wvOFzMHBSqpo+iYrMvLtulrgne6Suvekj/7k/hi0gRKkMdyrhpVJ1p9SEMKoU0VeB
 ySypmzw5jzIkNVpeW+BzHjMNtBh5gEVt8T4Zzklr35YRJvgDcZEFoBxGr6fash0imQzgDoLsi
 yRcsOlZKr1b+iTd3bZqqCaW/yzGWkXiggLYSdV+a9HP8qlQni83LP9XvQqFcDNJBraKGLpg91
 1yU97urDkWxFe020XUgTtOHPSpz5OrHMeSnq+zti8NOxjHFGrL/e+T+814tlJDftlrS2IsBVL
 vYVkQJ7d43l7NsvNSBIAuf6JkNJq4x4OqCKyh/QP0JJVTvL94DMx2T6WdR84pdoD4iny1xIKe
 CrkzRthYdwZyrGtd0u1kSsHdinezD15sbmt/QsRvOJ6CMIpmnSUrvjs7zkx75YqjwzfS0Fy+M
 XvriesO8Dl+P7za0YJisiXXBLx1HniHFBTgch/5pb5Vgb1luc//sPx5TovnTtpiULBQMcOZ5d
 rgQfOiTyQ8e9y9g/hBrhSEgekB0qjCsquGwRjti3RB0Jh3HAS5hS+WpUEGXI7N6ui58pYJOWj
 gFxlHdb2KTswo/RnxSWk9DlLBmY+LuDJRguv4fwjoRmA403dFGgU9VJnZDnFM42qmXFZFCxDO
 0a5gegIv63UxXfTrkZSlT9eKYChsTjuJYkE3u3K2uxbVdE/tHv3mLR2+z+rgDCYs5VkXLanVl
 ZHXFoLC7fQo/6+Pj9XjLkn1LX2TZ0c79kY5VL1nFwAPxa7H8jgyeS/NhqZENKYtQu+JQX2Vw5
 jw5t+FxlkLel+Vofzllg797yBKIbUCph7BwZ6SW0eR31x5dud66Od2lGBrBc219FYRZ+lcBae
 M+SW47HKwI7wk3BUz5NyugTbbe0y3Y6NOe/SVrR9wmr6akIeXaSSISpN3U9JlKsvZRXKkms9c
 xgYFsCzFH9n4f4FIMcVnre3JjAkQgQoa950mevzVFV5U13wbV75073+hc9ihJ1a94oGVV7SLS
 /6XLR9j3p3eXFHIWH
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> It is possible vfio_config_init() does not call vfio_cap_len(), and then
> vdev->msi_perm == NULL. Later, in vfio_config_free(), it could trigger a
> null-ptr-deref.

I suggest to add an imperative wording to the commit message.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=051143e1602d90ea71887d92363edd539d411de5#n151

Regards,
Markus
