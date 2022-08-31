Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBC55A7C23
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 13:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiHaL0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 07:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiHaL0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 07:26:17 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1793A6050F
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 04:25:39 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VAuKFc013491
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 11:25:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 cc : from : subject : message-id : date; s=pp1;
 bh=NI0G5j4Aqt2r/2/HHOOVZyzx9tGIoJc9OebtxACBHnw=;
 b=CEbGBkyIMwDETVrPvI7Dnb9sJ2yoQK9KwDftbrD734OwGEVptyTX8+iBW1Ww+No/WSJv
 7kLTqTh0hMuEkLdRHJiyGmzcRH2eDBa6tPq0Ht7yJ/tg9/N9caEobFWBu46TcDzsuDPb
 fiQtCBM8zAzGlTNapggB0tK+fY+tJNtSTKrlN98NDVv6un5tBoQArgOlCCIgD9G2ipXM
 wJr6HuApkj40g8wPz4fSq/PUzv34yFMS/iz60iQe4iLkdA2uq7YAsO5mYyopUKbqxSPv
 rNFiolghc7OmY7GtiABQ4BA+fChJysxBCYtHfAjIjfxbAnri61ZDW3ViSuNlPDdTadnm Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ja6b48ymp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 11:25:38 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27VB66B7027680
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 11:25:37 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ja6b48ym1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 11:25:37 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27VBMYTR014526;
        Wed, 31 Aug 2022 11:25:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3j7aw95581-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 11:25:35 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27VBPWMU32309650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Aug 2022 11:25:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFB3CA405B;
        Wed, 31 Aug 2022 11:25:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A88E3A4054;
        Wed, 31 Aug 2022 11:25:32 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.253])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 31 Aug 2022 11:25:32 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <47fe3036-3566-0118-ac0c-86f4a0d1c838@redhat.com>
References: <20220830115623.515981-1-nrb@linux.ibm.com> <20220830115623.515981-3-nrb@linux.ibm.com> <47fe3036-3566-0118-ac0c-86f4a0d1c838@redhat.com>
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add exittime tests
Message-ID: <166194513247.21737.14734474351149617278@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 31 Aug 2022 13:25:32 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SmzdatUSulKYj34sLREIHRJYhZHqSoD9
X-Proofpoint-GUID: 6Jf2FZUGOCD2XDq17Iyc8o0bVcGtgKDo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-31_06,2022-08-31_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=786
 impostorscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 phishscore=0 priorityscore=1501 spamscore=0 adultscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2022-08-30 14:52:14)
> I wonder whether we should execute this test by default, since nothing ca=
n=20
> fail here? I assume this is rather something that you want to run manuall=
y?

This could be one idea.

My idea was to run it even if it can't fail since the execution times are p=
rinted in log files. Collecting them may be interesting to establish a base=
line for later measurements. It also is what x86 does with their vmexit tes=
ts. In addition, running them doesn't hurt and makes sure the tests don't s=
uddenly break.

I will address your other comments in an upcoming iteration, thank you.
