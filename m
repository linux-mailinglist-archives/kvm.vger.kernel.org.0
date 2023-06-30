Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7572743BE1
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 14:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjF3MaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 08:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjF3MaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 08:30:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188941FFD;
        Fri, 30 Jun 2023 05:30:01 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35UCH6h8007255;
        Fri, 30 Jun 2023 12:30:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : cc : to : message-id : date; s=pp1;
 bh=uDWtMKlD2xe6wFahLSDNmJmGOuV5OV2j+L2uW8Is1o4=;
 b=ZldScI3CJce0fRbfAcHoKF6gXJK8JJKj/K9B9Opj/hNfxV3Xjl/Mu/k+K68iknhxZx6h
 SXtLtT7++UL8p7hl6zg4mBitg4CPAWNTSzc5FoN4VIpg4rJGb2OdUJM6/v0Fh5wCsBzR
 oOa7Wg2x6kifoDU30K4DRtVW9nYEjQIhKK3q1IFfKiEXxqjeC/dDfOhs0/4sHv9nbnBm
 8TN0aoRtBBz1r/d0GIYVqRoqgB/CnlMnqFf31cY31BRk1lSh/D4X3xzzVKigogcxbEll
 jlVGOvUYNIhnWD6uHBsZShgQI0TK915DSv8Ic/A2MoEYA1wnU6fLqoHIJVCenm1sXLvd ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rhxwtgahp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 12:30:00 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35UCIQeH011484;
        Fri, 30 Jun 2023 12:30:00 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rhxwtgaga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 12:29:59 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35U2AHMB019719;
        Fri, 30 Jun 2023 12:29:56 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rdqre4594-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 12:29:55 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35UCTqed23397062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 12:29:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F0EA2004E;
        Fri, 30 Jun 2023 12:29:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A8182004D;
        Fri, 30 Jun 2023 12:29:52 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.51.244])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 12:29:51 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230627082155.6375-1-pmorel@linux.ibm.com>
References: <20230627082155.6375-1-pmorel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v10 0/2] S390x: CPU Topology Information
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Message-ID: <168812819166.15775.3844560015451726762@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 30 Jun 2023 14:29:51 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oVXDLg4OerJawxdZaMFs-dnuWJQG9CBF
X-Proofpoint-ORIG-GUID: VDmmexvbBou0CVXDhojxJ_YlF4L0QJmS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_05,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306300103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-06-27 10:21:53)
> Hi,
>=20
> new version of the kvm-unit-test s390x CPU topology series.

This is now on our internal CI, so we can at least see that it doesn't brea=
k anything when the topology is not yet there :)
