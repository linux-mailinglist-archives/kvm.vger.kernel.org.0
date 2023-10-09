Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4FC97BE2E8
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 16:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbjJIOdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 10:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjJIOdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 10:33:50 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D44C5;
        Mon,  9 Oct 2023 07:33:49 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 399EWWIN003977;
        Mon, 9 Oct 2023 14:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : to : subject : message-id : date; s=pp1;
 bh=C3NDXNdTOMzjCwPAqD7u4id3iVSPC9zMEss1EEfelUM=;
 b=qUzkevlI8iwLRESLDfg3k0mQNXZnUR1gSkj6/7FE6O4lvTjtMrz980BWN31N3aSMt+FE
 Ya7iB+sHouvs+NNpL6oQUCLXfhs5NvUgSzWtq23XTT6NI9YVDPuuaUodLCR3hwIMXajn
 aettPNJRPcpqwby92b07T2rWo2EyyJQUCV5wcpSNP+wIqXBpMjVDKWzw/5SbldasfukQ
 in9wjcz82lxJGFCLrztynlgDBa1cE+js5NSHNb/4ne6/F+7/wS6LqQGXOhmR4z8QSN+h
 FHUeco3vt+5XrGr3DRfNKOQ6zokJ+MBYgyV12CS5LDKQnZ19e4MeNNdvMVhPjjsL2IYr wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tmkcar0xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 14:33:40 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 399EXdZk009669;
        Mon, 9 Oct 2023 14:33:39 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tmkcar0wt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 14:33:39 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 399CJdMA025927;
        Mon, 9 Oct 2023 14:33:38 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkjnn1jts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 14:33:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 399EXZrB16253622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Oct 2023 14:33:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 677DE20043;
        Mon,  9 Oct 2023 14:33:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30D8220040;
        Mon,  9 Oct 2023 14:33:35 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.78.248])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  9 Oct 2023 14:33:35 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <082a6b8b-6138-bf42-3f5e-0c2995bfe382@redhat.com>
References: <20230926120828.1830840-1-nrb@linux.ibm.com> <082a6b8b-6138-bf42-3f5e-0c2995bfe382@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>, andrew.jones@linux.dev,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1] arch-run: migration: properly handle crashing outgoing QEMU
Message-ID: <169686201472.13261.8530635358597101855@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 09 Oct 2023 16:33:34 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R7_ZpeaNNY1FtPo8CaL6JAfU2SRXuduN
X-Proofpoint-ORIG-GUID: 6uN1y6lsPdzSTob7ek_mIHEvb5XjqKEp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-09_12,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=689 lowpriorityscore=0 clxscore=1011 phishscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310090120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-10-09 13:29:38)
[...]
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>=20
> and pushed to the repository.

 Thanks!
