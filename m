Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10015A80CD
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 13:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfIDLDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 07:03:35 -0400
Received: from mout.web.de ([212.227.15.14]:42923 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbfIDLDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 07:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1567595011;
        bh=1C2g0mIwGrCmliZXJXrDTouzc5hVhVZovk4AroiNVOI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=EazjfG0aRD2RG2iIa2mnM1xcUplzsc65att08jzJUJver8uPchxMHtlUUeHoc9GpY
         TYNZB+ozZtbpRMxxWWQWaTIO+RwN2Um/ApaxT0jMFNU3GTGC8b6LBgL6OdOd2ShST8
         +bh1XpXnviSxxWGjox4a1MOOW45BWU/D4PHy2uyo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [10.0.0.32] ([85.71.157.74]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M1o4o-1iKEpt17BC-00toD2; Wed, 04
 Sep 2019 13:03:31 +0200
Subject: Re: [PATCH] kvm: Nested KVM MMUs need PAE root too
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
References: <87y2z7rmgw.fsf@debian> <87woeojsk0.fsf@vitty.brq.redhat.com>
From:   Jiri Palecek <jpalecek@web.de>
Message-ID: <ea7f6070-c129-9826-8a4e-e39e6d541f63@web.de>
Date:   Wed, 4 Sep 2019 13:03:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87woeojsk0.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:pOvVzNyUGrB6+SsIOL4G8UwliVYQXeva/i8WaTEgZQmoLmSfiRc
 /MZ+NCsqRCqwEskiIjzCnEnuXEu3L6cLKr3x6SJYRQkYb3l5JMsB0xxRw3OiJFi1Tpssas/
 uQ6I13y8F8kGA06o/bdVHhTmOfMYTQXxbTXPoFjVcswHrHSL6Mw1YOwXFGKpUh/vEXpkuV+
 9lcNyGMRmC8AdiHCh0+0g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:35Ogd5oAWCY=:45DI8hlq6f0Y9aWzwsltYC
 Zr0jTh1HY0c+FkpUejPRxY8UrisPy7U10EeOBT+31kxC4QsQR0QdFITaLF5Mh5NfiyjYOqlLw
 n/Wwspzb9bninLzS5qCL/xnSVh46Jleb+hwKLZJN3wP9DUgsb1/mERufhcccuZyloqLw2WEoZ
 BCahU+iUP+QaQ/kgd9TuDV6FRJKVbarh+Siu+vB4KqB2vQ8H7nOd8qMstzOv9szoq/Rs0oAiB
 vARb6ckT3ZN0zsS+eiqJ+96STlMGo+gYkrDm1PcmA6Ru4GhQ7NF58rEVt/VM+rofWkedlFd4E
 FNQ1tGUHHQg98N6RYHWZloKIAVYstFaraVLYQGqIwtdaZPGXXRBBCNrOvuoamQ+6VNhazaWis
 2mVVRM63XbLs39tFVQhHzGq9OmnQngI4N+9gwLkqKUPlVO749OmdlnBpQSqlpVrdYGhsMVuei
 KiChKxU5hpltbj09VWH3HpMU7MCV4IXXKOM7y8beeEZDJXW1U3HCTdl8nOrIdY9gVOf09QwKg
 GURztV6OYzEh5IrFs3BTDUztxF4ddripgPZEns99IwfcWs3cc3mgShErybW0bWR7KcroRfAMQ
 YVl4nArYuTpqim+doRIi2bhU2QJqKJ5L9kvXOW10OpL8ZFF6ZrlJBo1mFEfdkb/1FqpXDPQcB
 FbGSkyi9eoY2r662mNtVh8wjTkNmKkZmhj0eqcO7kGgRGTn5VAgbHl6FnQrBac9k7w8Ph9KXk
 pPLKb27wTjQOuO9Geky+k6hicTKa36I+zTMXNCyJN+YGr/+BnZRIUdTYzKt9pxJYT9th0GqX2
 wG+0Jq3OSpwGB16csnYa/in8X+waR5DUzCGbs7xb0v9CFsjI9TsLgDnoRvOcYTXF9oK7cV6vF
 d0ihMNuzeVoVBkPJsmLVS3ZLZ50od/nwNk6KUODtT3BL425pQYX0O/CrmQs82oKvgpl+owXaY
 uoWuFMS8pVS3ZZTwFkUbd3lNglHZnqs/g7ST44bjcXQPMY3X7ZWgRF2asamqqgQK/W2fQIz9C
 bBZh6IktPRPeq905M/a9VGVJ+6CjxglV8emzmZ2wXz9Epzfvn+NLMwxNnNKusl0KtCdBmuBsl
 h9YbakYBXKF2Y7x+Moz8dngVqLYqwjgx9JYi5HHzAVLlLea/1pmKA+V7u5Nojjn1zXWHIF3Ys
 APHKRiC1/Qbqvo0XIniOvR66F+sNJbu5Jo2P9o9ETwOobjXg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 04. 09. 19 11:53, Vitaly Kuznetsov wrote:
> Ji=C5=99=C3=AD Pale=C4=8Dek <jpalecek@web.de> writes:
>
> Your Subject line needs to be 'PATCH v2' as you're sending an updated
> version.

Yes, I wanted to make it v1.1 but forgot. Sorry

Regards

 =C2=A0=C2=A0=C2=A0 Jiri Palecek


