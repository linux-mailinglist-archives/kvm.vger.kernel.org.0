Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F118A7CC348
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 14:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343635AbjJQMgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 08:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbjJQMgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 08:36:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD40B0;
        Tue, 17 Oct 2023 05:36:41 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HCZ5W7000769;
        Tue, 17 Oct 2023 12:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=qnjBeGpybrqISjG9iz4ktfgJBXYdh2xrkmyOSnYOF3U=;
 b=FToMsb3Hib7fCyCKlsTTZAh0FlV1OklI9XdAa9dL9RLPUntrewa1j0OpLgYcg8k63jua
 6NYEZpDthGXVY4B8UVelOxsRkQr0RxkfsspRQL/PtOrkOXEOdKWe1SbUb2csGXtmg9KC
 IBi0B4Rg2pYNv1qgnW24ZZyBVN4zO7eeJaay8//9LSg810hxzWjZac28MybSKeommfzg
 UPCikanf7Qpthqu/3F+YbUX6Ea1G0DXbZMztELg776U2rh/j4dAFQijWiGye+3SPGXdQ
 nOdFdOeeeFGXH6qfLALmtrtCWp9kWby3xuFO3w/IyTdWGn/YS0UJmy0BVGR96S3keR+m qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tstd8g2t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Oct 2023 12:36:30 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39HCZ7Qj000862;
        Tue, 17 Oct 2023 12:36:29 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tstd8g2hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Oct 2023 12:36:28 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39HAq4qt026885;
        Tue, 17 Oct 2023 12:32:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tr5as94b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Oct 2023 12:32:38 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39HCWWH310355206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 12:32:33 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E452320040;
        Tue, 17 Oct 2023 12:32:32 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74D3520043;
        Tue, 17 Oct 2023 12:32:32 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.66.53])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 17 Oct 2023 12:32:32 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231011085635.1996346-7-nsg@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com> <20231011085635.1996346-7-nsg@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 6/9] s390x: topology: Rename topology_core to topology_cpu
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <169754595134.81646.14900608713165465789@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 17 Oct 2023 14:32:31 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7cbbhefekqkDWdob_JB0vzXa2L0O5t-W
X-Proofpoint-GUID: b_l-pyvfyYX9SJwbJa4NWrMzj94zOTbM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 phishscore=0
 mlxlogscore=832 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310170106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-10-11 10:56:29)
> This is more in line with the nomenclature in the PoP.
>=20
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
