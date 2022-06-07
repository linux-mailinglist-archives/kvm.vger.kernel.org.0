Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB6C5401C1
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 16:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343566AbiFGOtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 10:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343535AbiFGOtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 10:49:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D481DF504A;
        Tue,  7 Jun 2022 07:49:05 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 257EZkxO025293;
        Tue, 7 Jun 2022 14:49:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=fR1sZsUuBWTKDTdZYbBptbpvCL8/PrdUFkDE3PjDMjo=;
 b=XXpZUeXTZY3QOpSd02eeTF5+B2xKgOmUOZBebOP/cwsbTs4xhflvXF7+8ojLk+E5HOvy
 5ZqnoZq1av14bPfnx+ZfWBQ6wOWt69C6Ihw3OoxJDQeW3zTrIU5YO3saieyfExdIvSXI
 JQ4nVZd+rXwL653qo3JJzo9GUqkSNfKO2lXhuuoa1n+kUmOXKNcl9K+T4dj1kN+90uXC
 rB1TLnTTQ2cwYSF70y5xe/NCrIj1annxkCRWfoXMQkEdlo9uU9HMvnI4HNzSdG586FWi
 Ou6c7p3m4XBps5LLsFCkV4AQMsRI47CkXuS0F8ZEBp+66Oyjm23IcQPGi0hQZfpzHlGy +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj8bv8hnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 14:49:05 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 257En4aP014103;
        Tue, 7 Jun 2022 14:49:04 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gj8bv8hn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 14:49:04 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 257EMF5A024098;
        Tue, 7 Jun 2022 14:49:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3gfy19bwnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jun 2022 14:49:02 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 257Emx9n45154656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jun 2022 14:48:59 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DEE15204F;
        Tue,  7 Jun 2022 14:48:59 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1 (unknown [9.171.69.129])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 1E5975204E;
        Tue,  7 Jun 2022 14:48:59 +0000 (GMT)
Date:   Tue, 7 Jun 2022 16:48:57 +0200
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, scgl@linux.ibm.com, pmorel@linux.ibm.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] lib: s390x: better smp interrupt
 checks
Message-ID: <20220607164857.53dac498@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
In-Reply-To: <20220607164113.5d51f37d@p-imbrenda>
References: <20220603154037.103733-1-imbrenda@linux.ibm.com>
        <20220603154037.103733-3-imbrenda@linux.ibm.com>
        <20220607162309.25e97913@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
        <20220607164113.5d51f37d@p-imbrenda>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UzjtES5vSnszk44caiLGgPVb353X1c0m
X-Proofpoint-ORIG-GUID: Ir8596N4CDDl5VJrRF1MvnFGB7DvbOpD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_06,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 mlxlogscore=877 clxscore=1015 adultscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206070058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Jun 2022 16:41:13 +0200
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> yes I have considered that (maybe I should add this in the patch
> description)

Yes, and not just that; maybe rename expect_ext_int to expect_ext_int_on_this_cpu, same for register_io_int_func.
