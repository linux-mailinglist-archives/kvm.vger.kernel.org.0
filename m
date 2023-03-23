Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0082E6C68A7
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 13:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjCWMnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 08:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjCWMnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 08:43:08 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3655625B95;
        Thu, 23 Mar 2023 05:43:04 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NB07wT036814;
        Thu, 23 Mar 2023 12:43:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=RurCNe5zDku6bDWRB31OmgTxGYev7jwDzMxq3gTnlI0=;
 b=Elx/k19lOxuV03+mYBpRFlUBq6dzjXpQ5gDEU9NM7MCYaonQ4wdFbErxh92biqf0zmdR
 W9ZuhCEHtiHWu1QV+l/NVrwIO5n2nTUkvoBHKP36IhtrOQ6O0KIlMyIkuMx/yRClmlKa
 pQEK5Lyq2EtD6Oq1mAgYu4ha9gZCIXC02PLdp9sKpqNoe6alG+g2OvKp/PaVbNTNupQV
 ipOtowISsTM2W2pOXOzdbt4djjLzdDHp1WtSEiRaLM2bkXR8z0SO1f8GM0LXf0dehTlB
 JmyGEePnWS85coDjvGv1+ZOlX1qfMtXByyDj9JFrXSFy22TYjNLTIjZc3Ij9Tt13tZTo 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pggv7habp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 12:43:03 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32NBdMVQ007404;
        Thu, 23 Mar 2023 12:43:02 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pggv7hab9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 12:43:02 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NBagIh007893;
        Thu, 23 Mar 2023 12:43:01 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pd4x666bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 12:43:00 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NCgvcS36962736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 12:42:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 500AE2004D;
        Thu, 23 Mar 2023 12:42:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3056420049;
        Thu, 23 Mar 2023 12:42:57 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.6.128])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 12:42:57 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230301132638.3336040-1-nsg@linux.ibm.com>
References: <20230301132638.3336040-1-nsg@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1] s390x: spec_ex: Add test for misaligned load
Message-ID: <167957537692.13757.69612314579154837@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 23 Mar 2023 13:42:56 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EH4_qyzsAygtFKVMWomHTGJHXY_88grU
X-Proofpoint-GUID: _QbWI-tlsHaja3ukFoXg0pYyWCkbDwvO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230094
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-03-01 14:26:38)
> The operand of LOAD RELATIVE LONG must be word aligned, otherwise a
> specification exception occurs. Test that this exception occurs.
>=20
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

queued, thanks.
