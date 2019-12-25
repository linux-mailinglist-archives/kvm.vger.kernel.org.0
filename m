Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D8D12A58A
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 03:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfLYCNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 21:13:21 -0500
Received: from mail02.vodafone.es ([217.130.24.81]:7972 "EHLO
        mail02.vodafone.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbfLYCNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 21:13:21 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Dec 2019 21:13:20 EST
IronPort-SDR: HC12Fqd3Q68wPD69okaiNJVfDa4tSgRaog4OG2qf0+zZBG31RQFwree2qmOUDbV0qo7WyuaxNp
 gzhacsmBlE7g==
IronPort-PHdr: =?us-ascii?q?9a23=3AbEKAyBYXOB1r4u8gnYdzfhH/LSx+4OfEezUN45?=
 =?us-ascii?q?9isYplN5qZoMW5bnLW6fgltlLVR4KTs6sC17ON9fq6AydZvcnJmUtBWaQEbw?=
 =?us-ascii?q?UCh8QSkl5oK+++Imq/EsTXaTcnFt9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFR?=
 =?us-ascii?q?rlKAV6OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+MRu7oR/PusUIn4duJbs9xx?=
 =?us-ascii?q?TLr3BVZ+lY2GRkKE6JkR3h/Mmw5plj8ypRu/Il6cFNVLjxcro7Q7JFEjkoKn?=
 =?us-ascii?q?g568L3uxbNSwuP/WYcXX4NkhVUGQjF7Qr1UYn3vyDnq+dywiiaPcnxTbApRT?=
 =?us-ascii?q?Sv6rpgRRH0hCsbMTMy7WfagdFygq1GuhKsvxJxzY7OYI+LN/RwY6zScs8VS2?=
 =?us-ascii?q?daQsZcVTBODp+gY4cTEeYMO/tToYnnp1sJqBuzHQ+iC/nywTFSnH/23Kg60+?=
 =?us-ascii?q?U9EQHHwgwvBc8FvXPIrNXoMKcdTeG1w7TSwjXYdP5W3C3y6InMchw7vfGDQ7?=
 =?us-ascii?q?ZwftTJyUY1CwzJlE2QqZD8Mj6Ty+8DsHCb4vJ+We6yiWMrsRx9rzazyss2lI?=
 =?us-ascii?q?XEiZgZx17E+Ch/3Y07P8e3SFRhbt6hCJZQsiaaOJZoTc46WGFovTo6yqUBuZ?=
 =?us-ascii?q?6mYCgG0JQnyADba/yAa4WI5wjsVOeVITdimn1lfK6zihmo/Ui+ze3zS9O70F?=
 =?us-ascii?q?hNripDjNbArG4C1wfL5siGTPty4Fuh1C6R2wzO6OxIO104mKTHJ5I73LI9mY?=
 =?us-ascii?q?AfvErDEyPunUX5lq6WdkEq+uiy7OTnZ63rpoOBN49wlg7+M7khldakAekjNw?=
 =?us-ascii?q?gBRWmb+eCm2L3/40L5RKtFjuUsnabFqpzaPdgbqrajAwBJyoYj9wq/DzC+3d?=
 =?us-ascii?q?Qbg3kHKUlIeAyIj4f3IVHCOvP4Aumlg1Sqjjhrw+rKPrr7ApXCfTD/l+LiY7?=
 =?us-ascii?q?NV9UFR0kwwwMpZ6pYSDasOc8j+QkvgiNuNKhZxCxa1xuf7Cct0ntcaUHqVA6?=
 =?us-ascii?q?qYLKLMuFKTzvAoI+6JbY4R/jvgfasL/fnr2Fsw0WcHfKyowZoJYTjsAuliKE?=
 =?us-ascii?q?SVaGHEh94AFSEWsw4zVOXhzkWeB20AL02uVr4xs2loQLmtCp3OE9ig?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2FQEgDAwwJelyMYgtllgkSDFDcbIBK?=
 =?us-ascii?q?TQlQGdR2KEoUyg30VhhoMgVsNAQEBAQE1AgEBhECCIiQ4EwIDDQEBBQEBAQE?=
 =?us-ascii?q?BBQQBAQIQAQEBAQEIFgaFc0IBDAGBayKEF4EDDIEggwOCUymtdRoChSOEc4E?=
 =?us-ascii?q?2AYwYGnmBB4FEgjKFAgESAWyFIQSNRSGIS2GXfoI+BJYwDYIpAYw4A4JUiRG?=
 =?us-ascii?q?nIoI3VYELgQpxTTiBchmBHU8YDY0sji1AgRYQAk+FPogGgjIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2FQEgDAwwJelyMYgtllgkSDFDcbIBKTQlQGdR2KEoUyg?=
 =?us-ascii?q?30VhhoMgVsNAQEBAQE1AgEBhECCIiQ4EwIDDQEBBQEBAQEBBQQBAQIQAQEBA?=
 =?us-ascii?q?QEIFgaFc0IBDAGBayKEF4EDDIEggwOCUymtdRoChSOEc4E2AYwYGnmBB4FEg?=
 =?us-ascii?q?jKFAgESAWyFIQSNRSGIS2GXfoI+BJYwDYIpAYw4A4JUiRGnIoI3VYELgQpxT?=
 =?us-ascii?q?TiBchmBHU8YDY0sji1AgRYQAk+FPogGgjIBAQ?=
X-IronPort-AV: E=Sophos;i="5.69,353,1571695200"; 
   d="scan'208";a="317694185"
Received: from mailrel04.vodafone.es ([217.130.24.35])
  by mail02.vodafone.es with ESMTP; 25 Dec 2019 03:08:16 +0100
Received: (qmail 23719 invoked from network); 25 Dec 2019 02:04:13 -0000
Received: from unknown (HELO 192.168.1.88) (seigo@[217.217.179.17])
          (envelope-sender <tulcidas@mail.telepac.pt>)
          by mailrel04.vodafone.es (qmail-ldap-1.03) with SMTP
          for <kvm@vger.kernel.org>; 25 Dec 2019 02:04:13 -0000
Date:   Wed, 25 Dec 2019 03:04:04 +0100 (CET)
From:   La Primitiva <tulcidas@mail.telepac.pt>
Reply-To: La Primitiva <laprimitivaes@zohomail.eu>
To:     kvm@vger.kernel.org
Message-ID: <9752402.66025.1577239444596.JavaMail.javamailuser@localhost>
Subject: Take home 750,000 Euros this end of year
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Attn: Email User,

You have won, you are to reply back with your name and phone number for
claim.

La Primitiva




----------------------------------------------------
This email was sent by the shareware version of Postman Professional.

