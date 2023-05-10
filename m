Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F1F6FDC7A
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 13:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbjEJLSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 07:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236768AbjEJLSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 07:18:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDC649F9;
        Wed, 10 May 2023 04:18:05 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ABFblg005635;
        Wed, 10 May 2023 11:18:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : from : to : message-id : date; s=pp1;
 bh=0395cmz+MCMMiosjuoLXXu8KAfWmWHS87LpLD2FwDcE=;
 b=qyYxALf8tdP1mycZITa3dtbzANyKYK7vmOhOYkuIv528SIjEkR7V9COdjpMauRUIARyC
 6Z7BvL4METHZTpA1QwcTiXqrWSfVKPWakIuRSk2WZca42LtqGwjULyGc+yQKAUzWvudR
 nI6hjy+20/tOEW7KU5dxr7m1jtxieS87+dUZb7C04BwdCNVPttCicUO5PmEMNAExS3xs
 B351EYbN3LDTsmObLufdnx0fWRNxQx4CefYyizgkO8CjntoWqxtt+L1ubDbN9JFYtaeB
 tOAVbnRo1dfbBFmwddSAg1yy3R8yn1zc3SuX8jsEJrFO7oXcP8sL24I/Jzx1XQfwC/iS sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg95qsmaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 11:18:04 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34ABHDEu010688;
        Wed, 10 May 2023 11:18:04 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg95qsmaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 11:18:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 349NijNs017430;
        Wed, 10 May 2023 11:18:02 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qf84e9186-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 11:18:02 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34ABHw4W53543196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 11:17:58 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C99BE20043;
        Wed, 10 May 2023 11:17:58 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A958F20040;
        Wed, 10 May 2023 11:17:58 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.13.202])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 11:17:58 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230502130732.147210-8-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com> <20230502130732.147210-8-frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 7/9] s390x: uv-host: Properly handle config creation errors
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <168371747841.331309.8471274279877421106@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 10 May 2023 13:17:58 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MQ5C4cOqPaedxiHj6RgRfKqoxZgS9Q_3
X-Proofpoint-ORIG-GUID: 4PpQiUINlNuChNSSpC_qVFErNkSRs5Ev
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=968 bulkscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 clxscore=1015
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305100088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-05-02 15:07:30)
> If the first bit is set on a error rc, the hypervisor will need to
> destroy the config before trying again. Let's properly handle those
> cases so we're not using stale data.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

I am not a huge fan of the naming of cgc_check_data(), but since I can't
really come up with a better suggestion let's avoid the bike shedding and
be pragmatic:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
