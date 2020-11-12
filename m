Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592A42B050E
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 13:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgKLMje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 07:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgKLMjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 07:39:33 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B39C0613D1
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 04:39:32 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id 74so8185429lfo.5
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 04:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=phHTZy9VcDbb9pgFowve7MRmZ2w7fjsGN8ixnsXGeWA=;
        b=ISzQfOqXYqCKiN23ZQ0UJxv5xifQiL4u50kFmwe/NXYRFCEFCOPQd/9PNm608pN/Yf
         yE4imji0gflv1Adrtbf0t/h+uV4fR2Y3TApu4oEY1X4R0iDpg0PdgNd19+aCBvq80hp0
         ewDKyxWyJToQrhVDytj1U88fWQNtZfVp9dxr/sLelTrjrqIkqyV2cTF/zZ5RFICzLvZ1
         +gvglFKHOoP7osqxms7ThWrz0ofIsOvCzn4cmp6yYd96myOkoqESCE8TVODXuHRNaDxc
         kC9g/pLMdIAH88yutH1dCfkqZrmx+n7QFTfj6n7pRGVt5avVCm8jVIacj0dzol2Md3Zv
         6wyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=phHTZy9VcDbb9pgFowve7MRmZ2w7fjsGN8ixnsXGeWA=;
        b=eQTNmy8Y39+7BTOglfPuYxW/cGeP5YpJ+ZrbJAU/ynFZoX1yaMIMc0CdyBvvqCrEOu
         d3geSg11wx8AR6bqUsMVtKz7Sl1vSg7Sbpnu5fZft77TPgLPTMFUBUcB8S1XSOntfug0
         dQ0JEDhRrjJpohyusPlSQaKzU40ihjZIvHLqTFl6nBXpIxgVEInPP2g/jwns9Mzsn5mW
         0QFWUNLqgjg/rF+8NvBCTDXtRoRuypZ7Z4pRwbKYdN5CUxaS4aibIrcLnXv2Gu3i1D9y
         dojoZt9ikMemXDRsydPzstjyryh/2a0/miMk5BnvmpF5MDfEg1IohGv5/VgHKzmuI9nM
         NLtw==
X-Gm-Message-State: AOAM533zTXnjM5aCFfbtwi2f1fmercV8HULqoPHGiE/uBd7ZGQGiGXo9
        JQeuiQ79f95CQIRMxfIV4D/vK91jgl4WE9estLg=
X-Google-Smtp-Source: ABdhPJw+7cZX4tUmQ54GMhRx6g1I32aCLWxycOJANF124aCY53UoBdFRkNpc1a5PHlRvhJl7bWXzsOkuYjSlkniYhhE=
X-Received: by 2002:ac2:51b4:: with SMTP id f20mr1004022lfk.338.1605184771399;
 Thu, 12 Nov 2020 04:39:31 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6520:3848:b029:98:62d1:262f with HTTP; Thu, 12 Nov 2020
 04:39:29 -0800 (PST)
Reply-To: jennetteharris@hotmail.com
From:   Mrs Jennet Harris <tomwolf311@gmail.com>
Date:   Thu, 12 Nov 2020 12:39:29 +0000
Message-ID: <CADCmoOUTRyk53dtpCw04tYqzqON7gzs2vQjZdanCQPC3EOWHTw@mail.gmail.com>
Subject: =?UTF-8?B?UmUuIOacgOaEm+OBruS6ug==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

5pyA5oSb44Gu5Lq6DQoNCuiJr+OBhOS4gOaXpeOCkuOAguengeOBruODoeODvOODq+OBjOWBpeW6
t+OBq+OBguOBquOBn+OBq+S8muOBiOOCi+OBk+OBqOOCkumhmOOBo+OBpuOBhOOBvuOBmeOAguOB
k+OBruaJi+e0meOCkuWPl+OBkeWPluOBo+OBpuOCgumpmuOBi+OBquOBhOOBp+OBj+OBoOOBleOB
hOOAguengeOBr+OAgeOBguOBquOBn+OBjOOBk+OBruS4jeW/q+OBqueKtuazgeOBp+engeOCkuWk
seacm+OBleOBm+OBquOBhOOBk+OBqOOCkuS/oeOBmOOCi+OBn+OCgeOBq+iqoOaEj+OCkuaMgeOB
o+OBpuOBguOBquOBn+OBruOBqOOBk+OCjeOBq+adpeOBpuOBhOOBvuOBmeOAguengeOBrueqrueK
tuOCkueQhuino+OBl+OAgeW/g+OBq+inpuOCjOOBpuWKqeOBkeOBpuOBhOOBn+OBoOOBkeOCjOOB
sOW5uOOBhOOBp+OBmeOAgg0KDQrjgrPjg7zjg4jjgrjjg5zjg6/jg7zjg6vjga7mlYXjgrjjg6fj
g7Pjgr3jg7Pjg7vjg4rjg4nlpKvkurrjga7kuIDkurrjgaPlrZDjgafjgYLjgovjg4vjg7zjg4rj
g7vjgrjjg6fjg7Pjgr3jg7PjgZXjgpPjgafjgZnjgILnp4Hjga7niLbjga/jgrPjgrPjgqLjgajj
g4DjgqTjg6Tjg6Ljg7Pjg4njgpLmibHjgYboo5Xnpo/jgarjg5Pjgrjjg43jgrnjg57jg7Pjgafj
gZfjgZ/jgILnp4Hjga7niLbjga/np4HjgZ/jgaHjga7lpKfntbHpoJjjgpLmlK/mjIHjgZfjgabj
gYTjgarjgYTjga7jgafmmKjlubQxMeaciOOBq+auuuOBleOCjOOBvuOBl+OBnw0KDQrkuqHjgY/j
garjgaPjgZ/niLbjgYznp4Hjga7lkI3liY3jgpLov5HopqrogIXjgajjgZfjgabnp4Hjga7lm73j
ga7pioDooYzjgavpoJDjgZHjgZ/nt4/poY04OTDkuIfnsbPjg4njg6vvvIg455m+5LiHOeWNg+ex
s+ODieODq++8ieOBruOBn+OCgeOBq+mAo+e1oeOBl+OBvuOBmeOAgg0KDQoNCuitsua4oeW+jOOA
gTIw77yF44Gu44GU5pSv5o+044KS44GV44Gb44Gm44GE44Gf44Gg44GN44G+44GZ44CC44GV44KJ
44Gr44CB5oqV6LOH5Y+O55uK44Gu5LiA6YOo44KS44GU5o+Q5L6b44GV44Gb44Gm44GE44Gf44Gg
44GN44G+44GZ44CCDQrnp4Hjga/ku6XkuIvjga7mlrnms5XjgafjgYLjgarjgZ/jga7mj7Tliqnj
gpLlhYnmoITjgavmsYLjgoHjgabjgYTjgb7jgZnvvJoNCg0K77yIMe+8iemfs+alvealreeVjOOC
hOODm+ODhuODq+e1jOWWtuOBquOBqeOBruaKleizh+ebrueahOOBp+WIqeeUqOOBl+OBvuOBmeOA
gg0K77yIMu+8ieOBk+OBruOBiumHkeOBjOmAgemHkeOBleOCjOOCi+mKgOihjOWPo+W6p+OCkuaP
kOS+m+OBmeOCi+OBk+OBqOOAgg0K77yIM++8ieengeOBr+OBvuOBoDIw5q2z44Gq44Gu44Gn44CB
44GT44Gu5Z+66YeR44Gu5L+d6K236ICF44KS5YuZ44KB44KL44GT44Go44CCDQrvvIg077yJ56eB
44Gu5pWZ6IKy44KS5L+D6YCy44GX44CB44GC44Gq44Gf44Gu5Zu944Gn44Gu5bGF5L2P6Kix5Y+v
44KS56K65L+d44GZ44KL44Gf44KB44Gr44CB56eB44GM44GC44Gq44Gf44Gu5Zu944Gr5p2l44KL
44KI44GG44Gr5omL6YWN44GZ44KL44GT44Go44CCDQoNCuOBk+OBruWPluW8leOBruasoeOBruOC
ueODhuODg+ODl+OBruips+e0sOOBq+OBpOOBhOOBpuOBr+OAgeOBmeOBkOOBq+engeOBq+mAo+e1
oeOBmeOCi+OBk+OBqOOBjOmHjeimgeOBp+OBmeOAgg0KDQoNCuOBneOBk+OBp+OBguOBquOBn+OB
ruWNs+aZguOBruW/nOetlOOCkuW+heOBo+OBpuOBhOOBvuOBmeengeOBr+OBguOBquOBn+OBq+en
geiHqui6q+OBq+OBpOOBhOOBpuOCguOBo+OBqOipseOBl+OBvuOBmQ0KDQoNCuaVrOWFtw0K44OL
44O844OK44O744K444On44Oz44K944OzDQoNCg0KDQpEZWFyZXN0IE9uZQ0KDQpHb29kIGRheSB0
byB5b3UsIEkgaG9wZSBteSBtYWlsIG1lZXRzIHlvdSBpbiBnb29kIGhlYWx0aC4gUGxlYXNlIGRv
DQpub3QgYmUgc3VycHJpc2VkIHRvIHJlY2VpdmUgdGhpcyBsZXR0ZXIuIEkgYW0gY29taW5nIHRv
IHlvdSBpbiBnb29kDQpmYWl0aCB0byBiZWxpZXZlIHRoYXQgeW91IHdpbGwgbm90IGxldCBtZSBk
b3duIGluIHRoaXMgdW5wbGVhc2FudA0Kc2l0dWF0aW9uLiBJIHdpbGwgYmUgdGhhbmtmdWwgdG8g
eW91IGlmIHlvdSBjb3VsZCB1bmRlcnN0YW5kIG15IHBsaWdodA0KYW5kIHRvdWNoIHlvdXIgaGVh
cnQgdG8gaGVscCBtZSBvdXQuDQoNCkkgYW0gTWlzcyBOaW5hIEpvaG5zb24sIHRoZSBvbmx5IGNo
aWxkIG9mIExhdGUgQ2hpZWYgJiBNcnMuIEpvaG5zb24NCk5hZG8gIG9mIENvdGUgZCdJdm9pcmUu
IE15IGZhdGhlciB3YXMgYSB3ZWFsdGh5IGJ1c2luZXNzbWFuIHdobyBkZWFscw0Kb24gQ29jb2Eg
YW5kIERpYW1vbmQuIE15IGZhdGhlciB3YXMga2lsbGVkIGxhc3QgeWVhciBOb3ZlbWJlciBiZWNh
dXNlDQpoZSBpcyBub3QgaW4gc3VwcG9ydCBvZiBvdXIgcHJlc2lkZW50DQoNCkkgYW0gY29udGFj
dGluZyB5b3UgYmVjYXVzZSBvZiB0aGUgc3VtIG9mIFVTJDguOU0gKEVpZ2h0IE1pbGxpb24gTmlu
ZQ0KSHVuZHJlZCBUaG91c2FuZCBVbml0ZWQgU3RhdGVzIERvbGxhcnMpIHdoaWNoIG15IGxhdGUg
ZmF0aGVyIGRlcG9zaXRlZA0KaW4gYSBiYW5rIGhlcmUgaW4gbXkgY291bnRyeSB3aXRoIG15IG5h
bWUgYXMgdGhlIG5leHQgb2Yga2luLg0KDQoNCkkgd2lsbCBiZSBnbGFkIHRvIGdpdmUgeW91IDIw
JSBvZiB0aGUgbW9uZXkgZm9yIHlvdXIgYXNzaXN0YW5jZSBhZnRlcg0KdGhlIHRyYW5zZmVyLCBh
bmQgZnVydGhlcm1vcmUgeW91IHdpbGwgaGF2ZSBhIHNoYXJlIGluIHRoZSBwcm9maXQgb2YNCnRo
ZSBpbnZlc3RtZW50cy4NCkkgYW0gaG9ub3JhYmx5IHNlZWtpbmcgeW91ciBhc3Npc3RhbmNlIGlu
IHRoZSBmb2xsb3dpbmcgd2F5czoNCg0KKDEpIEkgd2lsbCB1c2UgaXQgZm9yIGludmVzdG1lbnQg
cHVycG9zZXMgc3VjaCBhcyBNdXNpYyBpbmR1c3RyaWVzIG9yDQpob3RlbCBtYW5hZ2VtZW50Lg0K
KDIpIFRvIHByb3ZpZGUgYSBiYW5rIGFjY291bnQgaW50byB3aGljaCB0aGlzIG1vbmV5IHdvdWxk
IGJlIHRyYW5zZmVycmVkIHRvLg0KKDMpIFRvIHNlcnZlIGFzIGEgZ3VhcmRpYW4gb2YgdGhpcyBm
dW5kIHNpbmNlIEkgYW0gb25seSAyMHllYXJzLg0KKDQpIFRvIG1ha2UgYXJyYW5nZW1lbnRzIGZv
ciBtZSB0byBjb21lIG92ZXIgdG8geW91ciBjb3VudHJ5IHRvDQpmdXJ0aGVyIG15IGVkdWNhdGlv
biBhbmQgdG8gc2VjdXJlIGEgcmVzaWRlbnQgcGVybWl0IGluIHlvdXIgY291bnRyeS4NCg0KUGxl
YXNlIGl0IGlzIGltcG9ydGFudCB5b3UgY29udGFjdCBtZSBpbW1lZGlhdGVseSBmb3IgbW9yZQ0K
Y2xhcmlmaWNhdGlvbiBvbiB0aGUgbmV4dCBzdGVwIG9uIHRoaXMgdHJhbnNhY3Rpb24uDQoNCg0K
QXdhaXRpbmcgeW91ciBpbW1lZGlhdGUgcmVzcG9uc2UgdGhlcmUgaSB3aWxsIHRlbGwgeW91IG1v
cmUgYWJvdXQgbXlzZWxmDQoNCg0KWW91cnMgU2luY2VyZWx5DQpOaW5hIEpvaG5zb24NCg==
