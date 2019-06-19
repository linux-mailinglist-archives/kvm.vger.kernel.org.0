Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52854B328
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 09:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbfFSHf2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 03:35:28 -0400
Received: from mail.acehprov.go.id ([123.108.97.111]:45818 "EHLO
        mail.acehprov.go.id" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfFSHf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 03:35:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.acehprov.go.id (Postfix) with ESMTP id 6EE8930546F0;
        Wed, 19 Jun 2019 14:23:44 +0700 (WIB)
Received: from mail.acehprov.go.id ([127.0.0.1])
        by localhost (mail.acehprov.go.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id mHceDRGWrctb; Wed, 19 Jun 2019 14:23:44 +0700 (WIB)
Received: from mail.acehprov.go.id (localhost [127.0.0.1])
        by mail.acehprov.go.id (Postfix) with ESMTPS id 3D02130542CB;
        Wed, 19 Jun 2019 14:23:40 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.8.0 mail.acehprov.go.id 3D02130542CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acehprov.go.id;
        s=327C6C40-AE75-11E3-A0E3-F52F162F8E7F; t=1560929023;
        bh=52PESuH/C2hYB4U2EfLHG/Elk+RBHFGehFYxprn7ClQ=;
        h=Date:From:Reply-To:Message-ID:Subject:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=vVRoUZ/hyKP5AzlCrAkhUzzqM5szlq6HbDnHkQW4F+JtCn0afGUKSw9rmFEEgo4Ko
         t3r7Mztz38qxwq7sV5HYnpT4zkFoHtahhqr7//cFXGJzB/T/EYd+rIbTo1ib6OsR/4
         uGSTF6F/TOsLrGJMQcuwcQ4LQiuvvcFY95K+zpDw=
Received: from mail.acehprov.go.id (mail.acehprov.go.id [123.108.97.111])
        by mail.acehprov.go.id (Postfix) with ESMTP id 2C11830546F0;
        Wed, 19 Jun 2019 14:23:39 +0700 (WIB)
Date:   Wed, 19 Jun 2019 14:23:39 +0700 (WIT)
From:   =?utf-8?B?UXXhuqNuIHRy4buLIGjhu4cgdGjhu5FuZy4=?= 
        <firman_hidayah@acehprov.go.id>
Reply-To: mailsss@mail2world.com
Message-ID: <1798349491.109741.1560929019149.JavaMail.zimbra@acehprov.go.id>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
X-Originating-IP: [223.225.81.121]
X-Mailer: Zimbra 8.0.4_GA_5737 (zclient/8.0.4_GA_5737)
Thread-Topic: 
Thread-Index: uDJjT+71VYVv2SCSld8Rd5O1Z0kOXg==
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Q0jDmiDDnTsKCkjhu5lwIHRoxrAgY+G7p2EgYuG6oW4gxJHDoyB2xrDhu6N0IHF1w6EgZ2nhu5tp
IGjhuqFuIGzGsHUgdHLhu68sIGzDoCA1IEdCIHRoZW8gcXV5IMSR4buLbmggY+G7p2EgcXXhuqNu
IHRy4buLIHZpw6puLCBuZ8aw4budaSBoaeG7h24gxJFhbmcgY2jhuqF5IHRyw6puIDEwLDkgR0Is
IGLhuqFuIGtow7RuZyB0aOG7gyBn4butaSBob+G6t2Mgbmjhuq1uIHRoxrAgbeG7m2kgY2hvIMSR
4bq/biBraGkgYuG6oW4geMOhYyB0aOG7sWMgbOG6oWkgaOG7mXAgdGjGsCBj4bunYSBtw6xuaC4g
xJDhu4MgeMOhYyBuaOG6rW4gbOG6oWkgaOG7mXAgdGjGsCBj4bunYSBi4bqhbiwgZ+G7rWkgdGjD
tG5nIHRpbiBzYXUgxJHDonk6CgpUw6puOgpUw6puIMSRxINuZyBuaOG6rXA6Cm3huq10IGto4bqp
dToKWMOhYyBuaOG6rW4gbeG6rXQga2jhuql1OgpFLW1haWw6CsSRaeG7h24gdGhv4bqhaToKCk7h
ur91IGLhuqFuIGtow7RuZyB0aOG7gyB4w6FjIG5o4bqtbiBs4bqhaSBo4buZcCB0aMawIGPhu6dh
IG3DrG5oLCBo4buZcCB0aMawIGPhu6dhIGLhuqFuIHPhur0gYuG7iyB2w7QgaGnhu4d1IGjDs2Eh
CgpYaW4gbOG7l2kgdsOsIHPhu7EgYuG6pXQgdGnhu4duLgpNw6MgeMOhYyBtaW5oOiBlbjogMDA2
LDUyNC5SVQpI4buXIHRy4bujIGvhu7kgdGh14bqtdCB0aMawIMKpIDIwMTkKCmPhuqNtIMahbiBi
4bqhbgpRdeG6o24gdHLhu4sgaOG7hyB0aOG7kW5nLg==
