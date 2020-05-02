Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4C71C26A4
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 17:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgEBPnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 11:43:16 -0400
Received: from mout.web.de ([212.227.15.3]:54377 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728286AbgEBPnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 11:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588434189;
        bh=w6C9TWp9gmTctpfHRMAdH0cFtsh0HD9/ryup91lA8LI=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=jPjNmGWCyYuFtDf0g2oAJiMBFSQw4jgkCy6gn9lXA1sMrhwc9w2Sqh8l0EFiTtRhz
         fIN5/DDNhc7p+3p7ThFwlY5ZwvfNGLO7GX9cxGJjGiuGr0/FVNzVwt3uWMK+z0jS5+
         /DJz/Zb4n2I8lgsX0lln7ZO3Gq9SO2525kjtAyW0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.93.244]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MGgJK-1jR4ow39Xe-00DslL; Sat, 02
 May 2020 17:43:08 +0200
To:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        =?UTF-8?Q?Christian_Borntr=c3=a4ger?= <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: KVM: s390/mm: Clarification for two return value checks in
 gmap_shadow()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>
Message-ID: <7f0b7ac0-d061-9484-bc5e-bdd9e32aa42b@web.de>
Date:   Sat, 2 May 2020 17:43:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:yUl9vw77GE5w3XREkoJr7h6aGc6mBfwWYm1X21eLDRSQrhvJwYo
 WxM7Tm9iVLjPadiRjn04uDNaRbl9d0iRJNsEIHYW0bv2z1y9z8HqYdJ9JOZ2d6XztRbu2MJ
 L8ObK5jltsa+BYiX1TP3BnKpxYFeDKLDcSbYDyQMq1qtQNiwprlZhBzJa3DL/KG5zy/AdrE
 WyAxL6Ow903KzVyijK2pw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:eBZDZzTNPvc=:mPM2P4ywaupRNhQli96Ske
 qF+S6NHMshiv1pCDld0LfE49MT4CytrudOOO/A8kAACMBP8nHCUAqkuhj0e4kXKswEF7dZxcE
 rETYuBEzqqqCHJA3b3c0do/m9y73Eojs5Jy/RlJiACSXCBkd+ZrgtklX6v0eVg19BeXddFoAe
 Ly+9Dz1jO3lOy58eGeiGRWEl04RJUJASQKtSH7q7QOXE28eCeu3q9j64SMqyQEvJXmeJhRqco
 mg9+s1XhmhabdE4nj3VN1yhA67rfmheMbnyiuJ9gB3ueUg3CgmD2JuPvGE58n2wb2NvNPnKlX
 1oZ4EirDcUA2iv2SFInTnQOW3bk+kMwp1aHvtgiS1RSPkObxBWkdVwVPaxwj9RukkRixnRvSV
 dsuIg5u4NjEElS7cDgh7cgFCOSZLmfP5BNl5ETfkM7P/2yINRecKEqlC0dJk8WBklSNSTrXrN
 CCVoaA1HRq2q3l4QHDtSOPZvYfcnrfvi/pM4nJ5Y5K3s3xgyGktUaxoJTssJsz2MWzlCxsum8
 XIR7OmPR4XPEcpOp412rdRmfS0Mgy2MOnGbVkuthbk+/iN0KxpndcbWwkmjuz/38Pe+I+esLX
 rOgAYb1Fq6tNLoRo+rjvxhtkK0jeCNGCUSW8sy47NpuYO5TUauexE4AAKkidxbxgwa6mSceQp
 0BdpmdVj+DjmkvBrmysOtO706lzkQujJNPLr4646q+jRPC2Un7yg4N1vURx1V4sVEbPzPNtlM
 fL3Qd+g1otDVj2Y8NAVquyoDImjoI6JhyXlqLgpV13J4AOlPyAkbLkLNGNcVSZP4A0ojJdOOl
 4ezbBONzIPnjo/T5m3MZxSHVLz49P4GQCkJ6mGFfF1owdOXaDtfnRfOYeiGOaFAaLD3tF9Fu5
 ZijZkZ0ddLhQiCwGCKH8fbuRUcy1hpa3bQihW4MB4nXXF1KfN3AcTOKhmMX6CnVrNn5p/pMwq
 CTZ4oVJim/KRaXe6L+ylRF6ZIunKcQ6d5M/HdIgp+919o+SJYHUGOBimIa5JCMv3pAdX397kk
 bYrlhVyqJ97cvLmW0SMlNt5GV3hHfTGG6JPJBoPXO0XFp8pwdrQVMLvwN/lNOWQQO9Ysqt2gi
 8L1q0OlNPu+Fyg4QPiI3jZEbslK8XMPQlUB9udXGCNSbGvtd0c7eMEXaeZUa+Ahbqh6ZI++O5
 wkcT0VIflEsQxdB732VXAW/Rete9n7C3yzq0rszXSbXB9AK1VCJPrTVHG1E7OeUWAGPvo9kCC
 IaE8x8X96W4yYxEOy
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

I have tried another small script out for the semantic patch language.
This source code analysis approach points out that the function =E2=80=9Cg=
map_find_shadow=E2=80=9D
is called two times by the function =E2=80=9Cgmap_shadow=E2=80=9D.
https://elixir.bootlin.com/linux/v5.7-rc3/source/arch/s390/mm/gmap.c#L1628
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/log/ar=
ch/s390/mm/gmap.c

Null pointer checks are performed at these places.
The function =E2=80=9Cgmap_find_shadow=E2=80=9D is documented in the same =
source file
that the pointer =E2=80=9CERR_PTR(-EAGAIN)=E2=80=9D can eventually be retu=
rned.
Are the referenced gmap data structures always initialised here?

Regards,
Markus
