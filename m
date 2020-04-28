Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6C21BBDBA
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 14:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgD1MjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 08:39:04 -0400
Received: from mout.web.de ([212.227.15.4]:39503 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgD1MjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 08:39:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588077540;
        bh=uQwbH454f0gvDC4JIzZ39otWeu4LRi8sg9802Ksokko=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=PSLkuXkhm9wJOYvkT6fPW2rQ9GgYn7OSK4xhbnUiGy5ev/jPwDJVvtgUsXRbvz1ba
         B9Vg/i41u24nbr+Vj56TR+Zq8S7M60z0mmQyxQXSOCjR9l9qfmjFnLPkCUb3OAuUST
         URyyI/SkWx9lGhlAlDfzA9Pe/wuDtdFLCXzW8Tu8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from luklap ([94.134.180.8]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MRD0p-1jbyjk499z-00UWhH; Tue, 28
 Apr 2020 14:39:00 +0200
Date:   Tue, 28 Apr 2020 14:38:50 +0200
From:   Lukas Straub <lukasstraub2@web.de>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, kernel@pyra-handheld.com
Subject: Against removing aarch32 kvm host support
Message-ID: <20200428143850.4c8cbd2a@luklap>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/MktA=Dv1EjHA4CX8vUSTchZ";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Provags-ID: V03:K1:5o4ibYrEfygVMB7pNk1k2Y4+srFg4x1KzaRFPI7d7wLoZFcv4vH
 Vsq+OvB/GYg1mAmK3bLY7rgy0eubW1zuLCFwfNVvZq5lNE3sFZFNxGCq9/oovSLH5FvLw4f
 W0+QXQvz5F67Zk9vytmVAGSSc/15VB76Djn3esUhprtqBmn3jL5abGso4cSy6MwnZSHEDR8
 2AZ4MpMIkuAO7pylAB0ng==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+jfAGiK0wF0=:sl66xQYxXjYqZNbOtftMWF
 LLuEF5v/C+v+Atvlp1i9q5y9nCQfzTOXCVsYQywev5yYt9HKoaWnHM7yleuLCL+FjRfcFicK/
 MmT4d25I7bOsgcsScjRLSvlzmr5+m6I5AXw7Ztf4s0JuKkRrQT2xlgQp7I42X5kcoZEaqN3Kp
 pDPljlxSoOc4n32Ul3WJ6M9t3YzwbGdlHxG6/7nhNexjx7hfg8syxXjbH0JPGR67znmchMa9X
 NQFDJIwUYRpoWZFKz594UjmFIAtmBeqaOklnFGoKpqOnuZ/Ks0Y1oUUwNSMuez9NANeiZcQuq
 oIgR5JtW/Hd4CoAg4WTPWfnmhuUE1cMhObuVQsSgUJDmCj++Gh+NGBAhtohUHTJvQ1th1PaCD
 uqKLYrWx7WiM6H6At/WtitOrYE/KqKxP2UXOjRAw/bVUGc8b//OX9c0xS/0vmUN9zW4eKC3Pm
 gV92s+nW1QJqddOJWHIk57CdGdnD68jxNRGQMj3WvpwrCkY12MJ9QK9yocvRMBY1lIq6j8dt+
 V7OqRyctTDyuAsFjFelghXArRKNq4+Yj9lbzdznrYUr5EUpiADzVotr6N6Zu2/uY6qUuicvZ7
 3Q1ocdcA5D6uvLvxxjbrswnsm3WwZtX0gaol2bCFW8weqYFo2rhG+E4jVe5JS8UjQ27QCtzbk
 ECF8nzeBnhTpPTKc3TMRomYWHRS+5vHQpUVPtj8Cm0xO9T2wx7VyLAVwgPQWLFRUN1KuESkns
 qDkmYJblujiVwCLH8uIiPcbODbnMllaGqBZ3UdlLROYEkScnpBud43PonxYCd01cQN9AM2NXA
 6yDs3PWI6Gn1JQiTX8CMQrzEr8Z4ZzLmoyMLk8yh6+BZR3hN6MH5ExpXyPxuFStvgOJZd20wJ
 DVDlxrQw8Gbqs+16FCiszyDVPcYoMPb66PgWteWcFdw7iWLvsZq245fl7VSuBzKq0p/vWvNNY
 TJGhuXCilZ7VEmDv45RZPuPpD41kHErLrftMxoGB78Jj+cAVi/fxtVjz00oSsFABpWIqYcClu
 L+Q8fEEG60LtRKQCBzqbi16ALTgwmTb4Lk2UuVw5dNQ33Aq/utBtDJNo3ktK3QJLmFF2N/lXh
 PgDrt+vfeTXZAtRqPxuLuHoXpb69fLwYMXup9FAxJpO8ZgYuDe4dRWQTyXrMYVQ5HWkykZb7H
 Wma5zkU/gy3vxLnE21L8cHlgdfepQ5XQno7uI4+cu9s6CUFB+wdVVUOOYHtW7O5BV3enOGYhY
 oy1ue9mrZZDs2revY
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/MktA=Dv1EjHA4CX8vUSTchZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello Everyone,
As a preorder of the Pyra handheld, (OMAP5 SoC with 2x cortex-a15 arm cores)
I'm against removing KVM host support for aarch32. I'm probably going to use
this device for more than 5 years and thus the latest lts-kernel is no opti=
on
for me.

Regards,
Lukas Straub

--Sig_/MktA=Dv1EjHA4CX8vUSTchZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAl6oI9oACgkQNasLKJxd
slg/3Q/8CDCjeuUL6fjcGSdcXaIIgwytnr1e6qlfxXgFXw2wiLfZAmyo5zeXdmqq
1TjIzMOdNowwMXTZVKBp5zGXvg5/VKcX/Sp2d/wk7QY8cxfeRwz9jwSywQ1D9aqa
Ipiqcy/HPtzOlzgUrzoXROEFEn9q/7+//b2vNkHnOY+pNA+m4m+PzY3ndY6CcpBO
rH/k0TdTP0jraDGhoh3qcL4+Zsrhfn0DRyH6W8gkF/aiW4FB96uMxyO0OZ+l/uK1
lxzazng8J84wmx4gbnnG+TqUK6gI4S92I7vnjx6qA2h5cPI9JKRJhc0dTZNzKErZ
XtznnB0eJM7BaMsMGritiichC/VXWzj4o95zlTieaymMMmjrK8BxqZ1vgU8NlT5O
3AI5Z5h0VFre9LQioHmMaz4Ls+0UvEQQ4sfpW8W02cMh4Pg6m7qUVcyjy569zkbT
44tWkAsbCF0LHba0pLDqvpJplRMxL+PBfQZ4JIyVWSDaLeVZxe4mv4JQXsP58UdJ
p6c1o2TIjqrkWVloFCEa0G54ndZNPlWdKGxx+lhaLuOkdjSWL5AF37A1rSPE2bwS
C7BESc5wZiizwE7bA+hHNjsatjDNVaoZr8SY1ejVoHLZLNr9ykOivEYbpJt2tONn
RdZ3ZRNGRqn9h8oTBLU5rlmBUQWDhsiDjfVnpZXklQEBVpoTrAI=
=B0xd
-----END PGP SIGNATURE-----

--Sig_/MktA=Dv1EjHA4CX8vUSTchZ--
