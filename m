Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E617CF5FB
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 12:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbjJSK7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 06:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbjJSK7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 06:59:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85856126;
        Thu, 19 Oct 2023 03:59:12 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39JAvBJI024359;
        Thu, 19 Oct 2023 10:59:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : cc : subject : message-id : date; s=pp1;
 bh=Wu9BgJYm7qCQ0w3vrJ0xL9ZFPF1eMSf4ekiJ38GJ344=;
 b=QlFkGfkyN51vywmnlZTnACFRF30pjDFx6uaZc1g4EmkQUIzXOkj8F07oc6iGWjqUSBiP
 G45SIIw53M1F7k06sjgrKkVuHWAmqboozSzvQvwtbuVZFKoCwNOK8kzKaQcQ0RJIVGRq
 vePw5a9DB6qRSyPmUkBKPpSxIpM5YW0tgYuOEJgkTdsWGRCmuDnjwb5i84FzFmdUZwf7
 QNI1meJj75U0NnpEd9vo45PFb8Vy7E7LApbE0Vth0VQh0CO4qUgmpsy5am2FKzYkiplx
 S1xCt+jyPOhI4MHB16V/hlH2UA63ix4kENkzs/pnQX2INEjI8iat/FXeMxptWgKuP+75 Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tu35g81kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 10:59:00 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39JAvuwZ027574;
        Thu, 19 Oct 2023 10:59:00 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tu35g81jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 10:59:00 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39JAn98V012949;
        Thu, 19 Oct 2023 10:58:58 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tr5pyrena-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 10:58:57 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39JAwspp27656704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 10:58:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C30520043;
        Thu, 19 Oct 2023 10:58:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5905120040;
        Thu, 19 Oct 2023 10:58:54 +0000 (GMT)
Received: from t14-nrb (unknown [9.152.224.84])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Oct 2023 10:58:54 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231011085635.1996346-10-nsg@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com> <20231011085635.1996346-10-nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 9/9] s390x: topology: Add complex topology test
Message-ID: <169771313413.80077.277349789650708438@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 19 Oct 2023 12:58:54 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EV2EydKpYhkD8Cm7V4MCPHQiZZo15vC4
X-Proofpoint-GUID: TXMjzkJCYluRGXQjwKSpebj5t5yISXBj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_08,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=911 spamscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310190093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2023-10-11 10:56:32)
> Run the topology test case with a complex topology configuration.

Can you add a TL;DR comment which summarizes the topology? And/or put the
script you used to generate the config in the commit message.
