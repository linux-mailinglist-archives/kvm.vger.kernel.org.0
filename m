Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33940717D77
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 12:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbjEaK6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 06:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234902AbjEaK6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 06:58:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1044CC5;
        Wed, 31 May 2023 03:58:09 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VAa528023387;
        Wed, 31 May 2023 10:58:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 in-reply-to : references : subject : cc : from : to : message-id : date :
 content-transfer-encoding : mime-version; s=pp1;
 bh=lzEcp0Lirk/h5Hj1UpXvnyacBYg9Q0pYFo9dGWwnh9s=;
 b=dr4aaxdKdSKlIMm7LIsk2W5F3kKsIBPWgcmK2iKIhnK052O8SW1X11rt/ND/B4SztZk5
 bB2ppFtzNUPFUtQDUFTClPvQNCbNTSX84GNUcZKnNRruofKZLKqZoHaUSP2+xmxx4jK3
 Kz1GKmGQPNWcoEBUbWJmi/zNJXnS77t9HOwBt4LczP3MeKEhOXHUg3koTBW2piD0b1nU
 WFdodWcN3pXl1toBGtijr2BnpJNhkaTP9MBzGoU439RifaMTvKSAYIeksqtEtoCfigG2
 epYwePihzF4KZEfKwKuWMUEMSbd10nVzN16mjCcuNqK38NQgAbapIS1xJoSoUmleVqNU iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwjvfukgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 10:58:08 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34VAmNav014839;
        Wed, 31 May 2023 10:58:08 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwjvfuker-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 10:58:07 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34V4Xbc4003811;
        Wed, 31 May 2023 10:58:05 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g51xwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 10:58:05 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34VAw2x744958166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 10:58:02 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE3F820043;
        Wed, 31 May 2023 10:58:01 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDA4C20040;
        Wed, 31 May 2023 10:58:01 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.88.234])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 31 May 2023 10:58:01 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <20230502115931.86280-1-frankja@linux.ibm.com>
References: <20230502115931.86280-1-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 0/7] s390x: Add PV SIE intercepts and ipl tests
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <168553068150.164254.1814616022935297468@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 31 May 2023 12:58:01 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ssu40lGjfAkAAkKv4smv16DD6EvS1Ejm
X-Proofpoint-GUID: i75l-bOwOpNnkMeMcHRlpJnxmeOP95XF
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_06,2023-05-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=904 adultscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 mlxscore=0 impostorscore=0 phishscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-05-02 13:59:24)
> Extend the coverage of the UVC interface.
> The patches might be a bit dusty, they've been on a branch for a while.

As discussed offline, adding tests which require gen-se-header to unittests=
.cfg
is not a good idea since we will have fails when it is not available.

My suggested fix is here:
https://lore.kernel.org/kvm/20230531103227.1385324-1-nrb@linux.ibm.com/

I've added this series to our CI and took the liberty of adding the missing
groups =3D pv-host
in the relevant patches. I can carry that along when picking for the PR, if
that's OK with you (provided the patch above is accepted in common code).
