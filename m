Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601246A0368
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 08:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbjBWHwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 02:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjBWHwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 02:52:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151F74AFC2;
        Wed, 22 Feb 2023 23:52:42 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31N5w8oP009904;
        Thu, 23 Feb 2023 07:52:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : cc : subject : message-id : date; s=pp1;
 bh=EGhjR+qxlEkQRIqOkdb1ulut+ojkzGkZHhRdtna0sVs=;
 b=GxYV/oJ+rPi8peYWwEyYbAVK20VV/M783Mx8gSYvXHyqD1IZBJyUOmIQu/pYkyWVCt0d
 Vstvm9Bp5YhiijbgqQ4hIo9aHp/jZXiTgrfrtUfwlgNmM0EqXW4YtWr8KH9eJsketM/o
 tv3IAvz1qNNh9AOTi9wu5a5I821V6BuhMJ0Yqca+QeWMy33TfoPoFXStiWqXYYPQVBpM
 ZuF3gfVypSXpQcy8TWSzplXM8DAtuUz6Ad1S8mU4zxIHzrstUEe2ZkPnRjgs2zpid963
 47Bjx9or0IldYxshCUKQDbhRImL+0JXP8Qe05AccdiDrFB34/v9bpKPixZ3HfO7vXT3f ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nx2fb2hga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 07:52:41 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31N7nCFY006779;
        Thu, 23 Feb 2023 07:52:41 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nx2fb2hfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 07:52:41 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31N76OVZ021018;
        Thu, 23 Feb 2023 07:52:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3ntpa6cudb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 07:52:38 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31N7qZtu54723004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 07:52:35 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D93020049;
        Thu, 23 Feb 2023 07:52:35 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17D0420043;
        Thu, 23 Feb 2023 07:52:35 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.63.253])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Feb 2023 07:52:35 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230222114742.1208584-1-nsg@linux.ibm.com>
References: <20230222114742.1208584-1-nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x: Add tests for execute-type instructions
Message-ID: <167713875438.6442.2406479682969262260@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Thu, 23 Feb 2023 08:52:34 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TCDG-XjRBzl1Ca0nSZ3DlFO-NtTtjhrE
X-Proofpoint-GUID: WVxMdwbe6IhRoRYKzCA9DleWT00_jsCo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-23_04,2023-02-22_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 phishscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-02-22 12:47:42)
> Test the instruction address used by targets of an execute instruction.
> When the target instruction calculates a relative address, the result is
> relative to the target instruction, not the execute instruction.
>=20
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
[...]
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 97a61611..6cf8018b 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -39,6 +39,7 @@ tests +=3D $(TEST_DIR)/panic-loop-extint.elf
>  tests +=3D $(TEST_DIR)/panic-loop-pgm.elf
>  tests +=3D $(TEST_DIR)/migration-sck.elf
>  tests +=3D $(TEST_DIR)/exittime.elf
> +tests +=3D $(TEST_DIR)/ex.elf

You didn't add your new test to unittests.cfg, is this intentional?

Otherwise:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
