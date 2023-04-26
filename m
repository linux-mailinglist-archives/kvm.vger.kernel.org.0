Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD59E6EF369
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 13:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240433AbjDZL16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 07:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240010AbjDZL15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 07:27:57 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D21270E;
        Wed, 26 Apr 2023 04:27:52 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QB8U2w030819;
        Wed, 26 Apr 2023 11:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=D2O5DH4oHHzOuUR7aMcJ5sugmRXJpjzkp8m4v8QtT1k=;
 b=fNny3NwkNk1f24XiKQZpQ4apNT/MiVhtbeRrI5nJT+dY783eIYxAImJQVndG3mhrBERd
 hKOc7x9duRSRETtAhE60zXJxOpyA680CtRc18poWDrYVno9vycHvOG+Awq+/E2iUtvEH
 dowb1HNkEwPJa9i2kc2pnOGGly5pDnRkTEBWmhrfZH/ORPLqQj00jggjhD7pF8v6UVpi
 kFU/BVcoRV/kWbppOSK+BzPD8QZzTa0R6pJANZ/UtRe9yjsqKEzqZS5Yqu+dnghIFtmo
 ULklyl1KAEC8kpyANF4a54bDknd4VSF0DtxreSB0dM8sdwcNhOtpfxKgC+9SZLjCc0g8 wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q72ksh0x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 11:27:51 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33QB977i005342;
        Wed, 26 Apr 2023 11:27:51 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q72ksh0w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 11:27:51 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q27aUQ001411;
        Wed, 26 Apr 2023 11:27:48 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q47772ay8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 11:27:48 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33QBRinc51970410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 11:27:44 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A62F02004B;
        Wed, 26 Apr 2023 11:27:44 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CCF620049;
        Wed, 26 Apr 2023 11:27:44 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.253])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Apr 2023 11:27:44 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230421113647.134536-5-frankja@linux.ibm.com>
References: <20230421113647.134536-1-frankja@linux.ibm.com> <20230421113647.134536-5-frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 4/7] lib: s390x: uv: Add pv guest requirement check function
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <168250846430.44728.17876956405267130513@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 26 Apr 2023 13:27:44 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _gebL08kgjC4DmpwZtYx0vEsisZIncB0
X-Proofpoint-ORIG-GUID: 6lhxy98BwHCUbGyVISvXdMNb-DDWUpSk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_04,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304260098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-04-21 13:36:44)
> When running PV guests some of the UV memory needs to be allocated
> with > 31 bit addresses which means tests with PV guests will always
> need a lot more memory than other tests.
> Additionally facilities nr 158 and sclp.sief2 need to be available.
>=20
> Let's add a function that checks for these requirements and prints a
> helpful skip message.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

with Claudios renaming suggestion:
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
